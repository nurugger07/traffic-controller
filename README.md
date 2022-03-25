# Traffic Controller Challenge

This challenge is designed to introduce you to finite-state machines (FSM) in Elixir. What is a FSM? A FSM is used to control sequential logical states for a system, or basically managing a finite number of states within a system. A common project to work with FSMs is the traffic controller example so that's exactly what we'll be building. 

## Description

There is a busy highway which is intersected by a less traveled farm road. The farm road has traffic sensors (C) on both the north bound and south bound lanes which alert the system of vehicles at the intersection. When no vehicles are on the farm road then the highway lights remain green. When a vehicle is detected on the farm road sensors, the highway traffic lights transition from green to yellow to red and the farm traffic lights turn green. The farm traffic lights remain green as long as a vehicle is detected but no longer than a set interval (25 sec). When either there are no vehicles on the farm road or the interval has expired, then the farm traffic lights transition from green to yellow to red and the highway traffic lights would transition to green. Even when vehicles are detected on the farm road the highway get at least a set interval before transitioning.

See the diagram for a visual representation of the problem.

![Intersection Diagram](/intersection-diagram.png)

## Requirements

Write an application that controllers traffic lights for a highway/farm road intersection. The lights will have three states: green, yellow, and red.

1. [ ] Use a FSM to manage the states of the farm/highway traffic lights.

2. [ ] Use a process to monitor for vehicles on the farm road and trigger the state changes for the traffic lights.

3. [ ] Use a long and short timer to manage transitions.

4. [ ] Some states imply others:
        - highway green = farm red
        - highway yellow = farm red
        - farm green = highway red
        - farm yellow = highway red

5. [ ] Log the states to an output to demonstrate the states/transitions.

## Constraints

* [ ] Use either a GenServer or gen_fsm. **DO NOT** use an open source library.

## Challenges

* [ ] Handle process crashes. If a signal process crashes gracefully "reset" the intersection.

* [ ] Record the state history for the intersection.
