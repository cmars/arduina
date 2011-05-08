/*

  Lighting effects for "?Quien es la muchachita?"

 */

#include "Tlc5940.h"

TLC_CHANNEL_TYPE channel;

#define NCELLS = 5;
#define LIGHTS_PER_CELL = 4;

/**
 * Each brain cell in the quilt consists of four high-power LEDs.
 */
int cellChans = {
  {  0,  1,  2,  3 },
  {  4,  5,  6,  7 },
  {  8,  9, 10, 11 },
  { 12, 13, 14, 15 },
  { 16, 17, 18, 19 }
}

/**
 * Each neuron oscillates with a sine function.
 * Track each radian sum per cell.
 */
float[] neuronOsc = { 0.0, 0.0, 0.0, 0.0, 0.0 };

/**
 * Various radian increments that are occasionally used to add jumpiness.
 */
float[] neuronInc = { 0.02, 0.049, 0.0079, 0.0169, 0.03 };

void setup() {
  // Randomize the cell start-states.
  for (int i = 0; i < NCELLS; i++) {
    neuronOsc[i] = random(100);
  }
  
  Tlc.init();
}

/**
 * Map a sine function value (-1.0 to 1.0) onto the range of LED brightness values.
 */
int valuePhase(float sine) {
  sine = (sine + 1.0) / 2.0;
  return (int)min(sine * 4096, 4095.0);
}

void loop() {
  for (int pi = 0; pi < points.length; pi++) {
    int r = (int)random(256);
    
    float rads = neuronOsc[pi];
    float phase = sin(pow(neuronOsc[pi], 0.9));
    if ((int)rads % 13 == 0) {
      phase = sin(tan(rads));
      rads += 0.8; // Nudge the phase forward to avoid too much flickering
    }
    
    int chan;
    for (int li = 0; li < LIGHTS_PER_CELL; li++) {
      chan = cellChans[pi][li];
      Tlc_set(chan, valuePhase(phase));
    }
    
    if (r % 23 == 0) {
      neuronOsc[pi] += neuronInc[r % points.length];
    }
    else {
      neuronOsc[pi] += 0.0079;
    }
  }
  
  Tlc.update();
}

