(59 + 3 + [-3, 0, 2, 4, 7, 11]).midicps.collect { |freq| Synth(\pad, [freq: freq]) }

Synth(\pad, [freq: 329.62])
Synth(\pad, [freq: 369.99])


Synth(\pad, [freq: 440])
