# System Diagrams

This section contains various diagrams explaining Kapetanios architecture and workflows.

## Architecture Diagrams
```{image} assets/kapetanios-system-design-draft.jpg
:alt: System Design v0.1.0
:class: custom-img
:width: 800px
```
**Figure. System architecture of Kapetanios.**

This system employs a Push and Pull architecture where the Kapetanios agent within the cluster initiates requests to the server for updates to the agent's configuration as provided by the user. Additionally, it sends data regarding metrics and the status of both the agent and the cluster as a whole. Importantly, the server never initiates requests to the agent, due to the architecture's design and the security protocols of the user's network infrastructure.

## Workflow Diagrams

## Component Diagrams

## Sequence Diagrams 