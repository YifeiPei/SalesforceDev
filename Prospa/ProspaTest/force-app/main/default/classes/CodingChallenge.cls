/*
 * Author Yifei Pei
 * Date 01/03/2022
 * CodingChallenge class to implement graph data structure
 * basic node connection and isConnected features
 */
public with sharing class CodingChallenge {
    // nodeMap to imitate Graph
    private Map<Integer,Set<Integer>> nodeMap;
    // visitStatus to store visited nodes
    private Map<Integer,Boolean> visitStatus;
    // algorithm stores the choice of BFS or DFS
    public String algorithm;

    // Constructor
    public CodingChallenge() {
        this.nodeMap = new Map<Integer,Set<Integer>> ();
        this.visitStatus = new Map<Integer,Boolean> ();
        // Choose BFS as default algorithm
        this.algorithm = 'BFS';
    }
    public CodingChallenge(String algorithmChoice) {
        this.nodeMap = new Map<Integer,Set<Integer>> ();
        this.visitStatus = new Map<Integer,Boolean> ();
        this.algorithm = algorithmChoice;
    }

    /*
     * Author Yifei Pei
     * Date 01/03/2022
     * Connect method to connect two nodes together
     * @param nodeSource is the source node to connect
     * @param nodeDestination is the destination node to connect
     * Assumption: this graph does not have directions so do two way connection in connect method
     */
    public void connect(Integer nodeSource, Integer nodeDestination) {
        if (connectValidation(nodeSource,nodeDestination)) {
            addEdge(nodeSource, nodeDestination);
            addEdge(nodeDestination, nodeSource);
        } else {
            // currently no further steps on validation failure
            System.debug('The node(s) you provided are out of the range');
        }
    }

    /*
     * Author Yifei Pei
     * Date 01/03/2022
     * isConnected method to check whether the two given nodes are connected in the Graph
     * @param nodeSource is starting node
     * @param nodeDestination is the ending node
     */
    public Boolean isConnected(Integer nodeSource, Integer nodeDestination) {
        // validation first
        if ((!this.nodeMap.keySet().containsAll(new Set<Integer> {nodeSource,nodeDestination})) || 
        (nodeSource == nodeDestination)) 
            return false;
        // prepare node visit map
        this.visitStatus.clear();
        for (Integer key : this.nodeMap.keySet()) {
            this.visitStatus.put(key,false);
        }
        
        /*
         * There are two ways to traverse a Graph: Depth First Search and Breadth First Search
         * When the node number is constant, the complexity of both of them is the same
         * Therefore, there isn't big difference for the two methods
         * provided both depthFirstSearch and breadthFirstSearch in case in the future further requirements are needed
         * e.g. DFS can find all possible paths from source node to destination node
         */
        if (this.algorithm == 'DFS') 
            depthFirstSearch(nodeSource,nodeDestination);
        else 
            // Make BFS the default algorithm
            breadthFirstSearch(nodeSource,nodeDestination);
        return this.visitStatus.get(nodeDestination);
    }

    /*
     * Author Yifei Pei
     * Date 01/03/2022
     * Depth First Search method to follow DFS algorithm
     */
    private void depthFirstSearch (Integer nodeSource,final Integer nodeDestination) {
        this.visitStatus.put(nodeSource,true);
        for (Integer adjacentNode : this.nodeMap.get(nodeSource)) {
            if (!this.visitStatus.get(adjacentNode)) 
                depthFirstSearch(adjacentNode,nodeDestination);
            if (adjacentNode == nodeDestination) 
                break;
        }
    }

    /*
     * Author Yifei Pei
     * Date 01/03/2022
     * Breadth First Search method to follow BFS algorithm
     */
    private void breadthFirstSearch (Integer nodeSource,final Integer nodeDestination) {
        List<Integer> visited = new List<Integer> {nodeSource};
        while (visited.size() != 0) {
            Integer node = visited.remove(0);
            if (node == nodeDestination) 
                break;
            for (Integer adjacentNode : this.nodeMap.get(node)) {
                if (!this.visitStatus.get(adjacentNode)) {
                    visited.add(adjacentNode);
                    this.visitStatus.put(adjacentNode,true);
                }
            }  
        }
    }

    /*
     * Author Yifei Pei
     * Date 01/03/2022
     * addEdge method to imitate edge adding in Graph
     * @param nodeSource is the source node to connect
     * @param nodeDestination is the destination node to connect
     */
    private void addEdge(Integer nodeSource, Integer nodeDestination) {
        Set<Integer> adjacent = this.nodeMap.get(nodeSource);
        if (adjacent == null){
            adjacent = new Set<Integer> ();
            this.nodeMap.put(nodeSource,adjacent);
        }
        adjacent.add(nodeDestination);
    }

    /*
     * Author Yifei Pei
     * Date 01/03/2022
     * connectValidation method to make sure the connected nodes are within the range
     * @param nodeSource is the source node to connect
     * @param nodeDestination is the destination node to connect
     */
    private Boolean connectValidation (Integer nodeSource, Integer nodeDestination) {
        if ((nodeSource < 0 || nodeSource > 99) || 
        (nodeDestination < 0 || nodeDestination > 99) || 
        (nodeSource == nodeDestination)) {
            return false;
        }
        return true;
    }
}
