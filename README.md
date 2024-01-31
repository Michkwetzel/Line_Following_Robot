# Mechatronics_II
 
This project involved the digital modelling of a line following robot in simulink. Usually this would've been done in person but instead we had to do it virtually due to the corona-virus pandemic.

The line following robot was digitally modeled using simulink. Some parameters of the robot were given to us, namely the H-bridge, Sensor and Wheeled Robot model. Our instructions were to design a sensor system that consisted of no more than 5 sensors, with a penalty for more sensors. Our robot would have to follow a number of different paths, some with slight turns and other with very sharp turns, and come to a stop once it is at the end of the track.

We started the project testing various different layouts of sensors. We solved this problem in a trial and error way. As we were instructed to use as little sensors as possible we first tried the model with only 3. After testing this however provided complication when a track with sharper turns was presented. We then defaulted to using all 5 with 1 sensor being on the line, 2 right next to the line and the other 2 a bit further away from the line. The robot completed the tracks in a desirable time.
