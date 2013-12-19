My goal was to create an algorithm that would generate N strongly connected components where each
node in the component would have a minimum of N links to other nodes in the component.

I implememnted non recursive postorder dfs, and kosaraju's algorithm to generate strongly connected components.
Unfortunatly the dataset I was working with (pages and links from simplewiki wikipedia page 137865 pages, 3621322 links)
was too large, and getting connected components caused out of memeory exceptions.

Despite efforts to reduce the algorithms memory footprint I was unable to genereate strongly connected components.

This is a rails project so it can take some effort to set up. The easiest way to show you the running code will be for me to
launch an AWS instance. This project cannot run on a free micro, so I'd have to spin up a medium instance. When you want to test
the project email me and I'll launch the instance, send you the URL to view the website, and provide the keys so you could login to the
server yourself to view the code.

app/models/wiki.rb
 -> loading for parsing wikipedia data dumps into the database

app/models/algs/df_order.rb
 -> Non recursive dfs postorder

app/models/algs/connected_components.rb
 -> Non recursive kosaraju implementation
