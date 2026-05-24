# State Machine Design – Weather System

## States

- Sunny
- Cloudy
- Rainy
- Stormy

## State Diagram

```text
Sunny  ---- after 3 seconds ---->  Cloudy
Cloudy ---- after 3 seconds ---->  Rainy
Rainy  ---- after 3 seconds ---->  Stormy
Stormy ---- after 3 seconds ---->  Sunny