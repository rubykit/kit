Events

On top of CQRS being a superior approach if we could get it “for free”, decoupling / having clear “API”/”interfaces” is key. (Think original OOP meaning about messaging/encapsulation).

Firing events to be consumed by other services is a common pattern that needs to be unified in the app. The 2 obvious “consumers” right now would be a local Event Store & Segment (and/or other services directly).

Events should be “generic”, as in: not forged depending on how they are going to be consumed.
Vero got this right: the external service should have a way to hydrate the event for its own need.


- Event log: https://kickstarter.engineering/event-sourcing-made-simple-4a2625113224
- Rails implementation: https://railseventstore.org/
- "Applying CQRS & Event Sourcing on Rails applications": https://www.youtube.com/watch?v=cdwX1ZU623E


Ressources
- https://kickstarter.engineering/event-sourcing-made-simple-4a2625113224