
Inertial Compensation for Platform Movement of an Instrumented Treadmill
============================================================================

This is the source code which reproduces the results for the paper entitled:

"<insert final paper citation here>"

Instrumented treadmills provide a convenient means for inverse dynamic gait analysis.  
Recently, these instrumented treadmills have the capability of translating and rotating
the walking surface.  Load cells, located directly underneath the force plate, incorrectly
add the inertia of the moving mass of the treadmill to the measured ground reaction 
forces (GRF) of the test subject.  This codes provides a computation method for reducing
these inertial errors and produces all results shown in the above publication.


Dependencies
============

- Matlab R2014b (8.3.0.532)
- Signal Processing Toolbox (Version 6.21)

Basic Installation
==================

Download the source code and data from the Git repository:

    $ wget https://github.com/csu-hmc/inertial-compensation/archive/master.zip
    $ unzip inertial-compensation-master.zip
    $ cd pitch-moment-compensation-master

Usage
=====

The complete results can be computed by starting Matlab with the main source
code directory in your Matlab path and typing the following at the command
prompt:

    >> inertial_compensation_test

Once the function has run you will find all the plots in the `Results`
directory. For the cutoff frequency of interest, a table of results including
the reduction in the root-mean-square (RMS) between uncompensated and
compensated force (Fxyz,Mxyz) and the percent difference between the them

Computation Steps
=================

The data processing pipeline follows this general process:

1. Specifies filenames located in the `Data` directory.
2. Parses pertinent data from tab separated ACSII data files (`data_parser.m`). 
   Data includes the timestamps, recorded 3D coordinates of reference markers 
   located along the treadmill frame, recorded 3D force plate data from two force 
   plates, and recorded 3D accelerations of 4 accelerometers located on each
   rigid corner of the treadmill
3. Sets a range of desired cutoff frequencies for the lowpass filter (1-20 Hz).
   Also sets a cutoff frequency of interest (6 Hz).
4. Filters signals (markers,forces, accelerations) with the cutoff frequency. Truncates
   the first and last second of all data
5. Adds signal delay to the force and acceleration signals (`add_delay.m`). Truncates
   any NaN from all data
6. Computes a matrix of calibration coefficients through linear least squares 
   between the measured accelerations (input) and force signals (output).  
   (`compensation.m`)
7. Multiplies the recorded accelerations from another trial with the calibration
   coefficients.  Subtracts the result from the recorded force signals (`compensation.m`)
8. Performs a coordinate transformation on the compensated forces ('transformation.m') 
   using the Soderquist method (`soder.m`). The speed soder method is sincreased through 
   multidimensional matrix multiplication (`mmat.m`)
9. Plots the uncompensated vs. compensated force signals (Fx,Fy,Fz,Mx,My,Mz) for
    force plate 1 (`plot_compensation_graph.m`)
10. Performs the inverse dynamic analysis on recorded walking data.  Adds uncompensated
    and compensated force signals to the walking data to see the affect on hip, knee, and
	ankle joint torques.  Plots the results (`sensitivity_analysis.m`)
11. Computes the RMS of the uncompensated and compensated force signals, as well as the 
    percent reduction. Displays a table of results for the desired frequency (6 Hz)
	(`calculate_statistics.m`)
12. Shows a comparison of RMS with respect to the filter frequency for
    compensated and uncompensated force and moment signals (Fxyz, Mxyz). If the range of
    the cutoff frequencies is 1, then the graph will not generate. (`plot_frequency_graphs.m`)
13. Saves the graphs to the `Results` data directory.
