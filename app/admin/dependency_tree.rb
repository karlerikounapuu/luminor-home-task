ActiveAdmin.register_page "Dependency Tree" do
  menu priority: 2, label: "Dependency Tree"

  content title: "Dependency tree" do
    div id: "graph-container", style: "width: 100%; height: 800px; border: 1px solid #ccc;" do
      para "Loading graph...", id: "loading-message"
    end

    script src: "https://unpkg.com/cytoscape@3.28.1/dist/cytoscape.min.js"
    script do
      raw <<-JS
        document.addEventListener('DOMContentLoaded', function() {
          fetch('/admin/dependency_tree/data')
            .then(response => response.json())
            .then(data => {
              document.getElementById('loading-message').style.display = 'none';

              var cy = cytoscape({
                container: document.getElementById('graph-container'),

                elements: data,

                style: [
                  {
                    selector: 'node',
                    style: {
                      'background-color': '#3b82f6',
                      'label': 'data(label)',
                      'color': '#fff',
                      'text-valign': 'center',
                      'text-halign': 'center',
                      'font-size': '12px',
                      'width': '60px',
                      'height': '60px',
                      'text-wrap': 'wrap',
                      'text-max-width': '80px'
                    }
                  },
                  {
                    selector: 'edge',
                    style: {
                      'width': 2,
                      'line-color': '#94a3b8',
                      'target-arrow-color': '#94a3b8',
                      'target-arrow-shape': 'triangle',
                      'curve-style': 'bezier',
                      'label': 'data(label)',
                      'font-size': '10px',
                      'text-rotation': 'autorotate',
                      'text-margin-y': -10
                    }
                  },
                  {
                    selector: 'node:selected',
                    style: {
                      'background-color': '#ef4444',
                      'border-width': 3,
                      'border-color': '#dc2626'
                    }
                  }
                ],

                layout: {
                  name: 'breadthfirst',
                  directed: true,
                  spacingFactor: 1.5,
                  animate: true,
                  animationDuration: 500
                }
              });

              // Click event to show CI details
              cy.on('tap', 'node', function(evt){
                var node = evt.target;
                var ciId = node.id();
                window.location.href = '/admin/configuration_items/' + ciId;
              });
            })
            .catch(error => {
              document.getElementById('loading-message').innerHTML = 'Error loading graph: ' + error;
            });
        });
      JS
    end
  end

  # Custom controller action to provide graph data
  page_action :data, method: :get do
    nodes = []
    edges = []

    ConfigurationItem.includes(:item_type, outgoing_relationships: :relationship_type).each do |ci|
      nodes << {
        data: {
          id: ci.id,
          label: ci.name,
          type: ci.item_type.name
        }
      }

      ci.outgoing_relationships.each do |rel|
        edges << {
          data: {
            id: "edge-#{rel.id}",
            source: rel.dependent_configuration_item_id,
            target: rel.dependency_configuration_item_id,
            label: rel.relationship_type.name
          }
        }
      end
    end

    render json: nodes + edges
  end
end
