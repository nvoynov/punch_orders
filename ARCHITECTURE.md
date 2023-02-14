% Architecture Exercise

Step out a bit from the Clean Architecture and try different architecture technics

# Layered, Services, ..?

What is me services layer of services and entities? It's business logic layer that uses plugins for storing data.

In case of RabbitMQ, is it Messaging Layer?

# Services?

# Architecture styles

## Pipeline

(also known as the pipes and filters architecture). As soon as developers and architects decided to split functionality into discrete parts, this pattern followed.

The pipes and filters coordinate in a specific fashion, with pipes forming one-way communication between filters, usually in a point-to-point fashion.

**Pipes** in this architecture form the communication channel between filters. Each pipe is typically unidirectional and point-to-point (rather than broadcast) for performance reasons, accepting input from one source and always directing output to another. The payload carried on the pipes may be any data format, but architects favor smaller amounts of data to enable high performance.

**Filters** are self-contained, independent from other filters, and generally stateless. Filters should perform one task only. Composite tasks should be handled by a sequence of filters rather than a single one.

Four types of filters exist within this architecture style:

- **Producer** The starting point of a process, outbound only, sometimes called the source.
- **Transformer** Accepts input, optionally performs a transformation on some or all of the data, then forwards it to the outbound pipe. Functional advocates will recognize this feature as map.
- **Tester** Accepts input, tests one or more criteria, then optionally produces output, based on the test. Functional programmers will recognize this as similar to reduce.
- **Consumer** The termination point for the pipeline flow. Consumers sometimes persist the final result of the pipeline process to a database, or they may display the final results on a user interface screen.


# Face

`face.rb` actually does a lot of work. It accepts requests, locates and calls domain service, present the service call result. But maybe it should be redesigned into filters that do just one thing - accept, locate, call, present?

In case of RabbitMQ "respond" to queue might be added.

Rack Middleware is rather for HTTP, not for locate, call, present. But "controller" should be certainly split into call domain service, present result  
