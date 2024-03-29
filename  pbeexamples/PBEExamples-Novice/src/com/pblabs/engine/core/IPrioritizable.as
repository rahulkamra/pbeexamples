package com.pblabs.engine.core
{
    /**
     * Minimal interface required by SimplePriorityQueue.
     * 
     * <p>Items are prioritized so that the highest priority is returned first.</p>
     * 
     * @see SimplePriorityQueue
     */
    public interface IPrioritizable
    {
        function get priority():int;

        /**
         * Change the priority. You only need to implement this if you want
         * SimplePriorityHeap.reprioritize to work. Otherwise it can
         * simply throw an Error.
         */
        function set priority(value:int):void;
    }
}