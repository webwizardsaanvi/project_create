import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

// 1. Define the model once
final _model = GenerativeModel(
  model: 'gemini-2.5-flash', // Use 1.5, not 2.5
  apiKey: 'AIzaSyCv7bdqLvCTTe6pCqfwNfJ7Jh6m7dtUttc', // Your key
);

Future<String> askAI(String userInput) async {
  // 2. Your specific course data
  final data = [
    {
    "course_code": "1010",
    "categories": [
      "Intro to ECSE",
      "core",
      "ENGR 2050 - Intro to Engineering Design",
      "Learned Concepts ? General Engineering Skills ? Using analytical/mathematical, simulation, and experimental methodology to verify the correct function of a system design ? Writing a set of linear equations in matrix form ? Defining a system by creating a block diagram ? Creating appropriate documentation for design, analysis, and evaluation of a system ? Creating a 4 year plan of study ? Basic Electrical & Computer Systems Engineering Skills ? Using a breadboard to prototype circuits ? Identifying resistors by their color bands ? Basics of using Matlab and Simulink ? Measuring voltage and current in a circuit using the M2K or Analog Discovery 2 personal instrumentation board and the associated software ? Using LTSpice to simulate and analyze circuits ? Combining RLC circuit elements in series and parallel",
      "Information Science and Systems"
    ]
  },
  {
    "course_code": "1090",
    "categories": [
      "Mechatronics (Hardware/Software)",
      "Control and Autonomy",
      "Learned Concepts\n? General Engineering Skills\n? Using analytical/mathematical, simulation, and experimental methodology\nto verify the correct function of a system design\n? Writing a set of linear equations in matrix form\n? Defining a system by creating a block diagram\n? Creating appropriate documentation for design, analysis, and evaluation of\na system\n? Creating a 4 year plan of study\n? Basic Electrical & Computer Systems Engineering Skills\n? Using a breadboard to prototype circuits\n? Identifying resistors by their color bands\n? Basics of using Matlab and Simulink\n? Measuring voltage and current in a circuit using the M2K or Analog\nDiscovery 2 personal instrumentation board and the associated software\n? Using LTSpice to simulate and analyze circuits\n? Combining RLC circuit elements in series and parallel? Skills Involving Individual Circuit Elements ? Voltage divider ? Interpreting IV characteristics of linear and non-linear devices, including resistance and differential resistance ? Interpreting transfer characteristics of op-amp circuits, including the saturation voltage and the gain in the linear regime ? Identifying and applying basic op-amp amplifier circuits: inverting amplifier, non-inverting amplifier, voltage follower, differential amplifier, weighted inverting summer ? Identifying and applying basic op-amp comparator circuits: non-inverting comparator, inverting comparator ? Setting the reference level for a comparator-based decision-making circuit ? Signals and Systems Skills ? Differentiating between DC and AC signals ? Representing sinusoidal waves in both the time and frequency domains ? Interpretation of plots of signals in the frequency domain ? Explain the concepts of Fourier Analysis and Fourier Synthesis of a signal ? Application of digital filters to audio signals to isolate or eliminate particular frequency ranges (in Matlab or Simulink ? Circuit Analysis Skills\n? Circuit Analysis Methods\n? KVL/KCL/Ohm?s Law\n? Circuit Reduction\n? Nodal Analysis\n? Superposition\n? Basic analysis of cascading op-amp circuits\n? Transfer Functions\n? Derivation of transfer functions for RC, RL, and RLC circuits\n? Evaluation of transfer functions at low and high frequencies\n? Sketching a transfer function vs. frequency\n? Calculating the magnitude of a transfer function.\n? Interpreting Bode plots (magnitude: pass band and stop band; corner and center\nfrequencies)\n? Determination of the filter type of an RC, RL, or RLC circuit from the transfer function\nevaluated at frequency extremes or from the Bode plot",
      "Electrical and Power System"
    ]
  },
  {
    "course_code": "2010",
    "categories": [
      "Electric Circuits",
      "core",
      "MATH 2400",
      "Follow-Up Courses ? 2050 ? Used skills: 2010.2, 2010.3 ? 2100 ? 2110 ? Used skills: 2010.3 ? 2210 ? 2410",
      "? Developed Skills\n? Solving linear ODE with\nIC\n? 2010.1 ? Complex\nalgebra and phasors\n? 2010.2 ? Sketching and\ninterpreting Bode plots\n? Simulation vs\nExperimental data\n? MATLAB\n? LTSpice\n? Personal\nInstrumentation ? Learned Concepts\n? 2010.3 ? Kirchoff laws\nfor circuit analysis\n? Frequency domain\nanalysis\n? Laplace transform\n? Transfer function\n? Filters\n? Time domain analysis\n? 2010.3 ? RLC\nelements\n? 2\nnd order systems\n? Resonance",
      "Electronics and Photons"
    ]
  },
  {
    "course_code": "2050",
    "categories": [
      "Intro to Electronics",
      "core",
      "PHYS 1200/1250 ECSE 2010",
      "ECSE: ? 4030? 4040? 4050? 4080? 4220? 4310? 4670",
      " Learned Concepts? Benchtop instrumentation? Building simple electronics circuits",
      "Computer System Design"
    ]
  },
  {
    "course_code": "2100",
    "categories": [
      "Fields and Waves",
      "core",
      "PHYS 1200, MATH 2010 ECSE 2010",
      "Learned Concepts? Unit 1: Transmission Lines? Basic transmission line theory? Standing waves vs. traveling waves on transmissionlines? Convert a sinusoidal wave expression to phasornotation or vice versa? Conceptually understand and calculate waveproperties: velocity, frequency, wavelength, andphase constant.? Conceptually understand and calculate transmissionline properties: inductance and capacitance per unitlength, characteristic impedance and attenuationconstant.? Matched vs. unmatched transmission lines at theload. Calculate the reflection coefficient at the load,standing wave ratio, load impedance, andcharacteristic impedance? Calculate transient behavior of a short pulse or DCvoltage propagating on a lossless transmission line? Determine the amount of power transmitted to aload by a lossless or low-loss transmission line? Calculate the input impedance of a losslesstransmission line with an arbitrary length and loadimpedance? Use a Smith Chart to plot and determine varioustransmission line parameters and calculate a single-stub match for an arbitrary load impedance Unit 2: Electrostatics? Electrostatic field analysis? Constant current field analysis? Understand the geometry of all surface and volumeintegrals in rectangular, cylindrical and sphericalcoordinates and specify all differential elements? Calculate or determine:? Potential difference between two points given theelectric field? Potential in a region via Laplace?s/Poisson?s equation(analytically and finite difference method)? Electric field using Gauss?s Law? Electric force using Coulomb?s Law? Capacitance of a given distribution of conductorsand/or dielectrics? Energy density in an electric field? Conditions for dielectric breakdown for a givendielectric medium? Conceptually understand the properties of electricmaterials and the consequences of electricpolarization? Evaluate a static electric field at the boundarybetween two materials with different permittivitiesincluding dielectrics and perfect conductors? Understand the relationship between and be able tocalculate conductivity, current density, and theelectric field. Unit 3: Magnetostatics? Magnetic circuit analysis? Calculate or determine:? Magnetic field using Ampere?s Law? Magnetic vector potential based on a magnetic field orvice versa? Electromotive force based on a changing magneticfield or vice versa? Inductance of a given distribution of currents and/ormaterials? Energy density in a magnetic field? Magnetic force across a boundary using the magneticenergy pressure? Magnetic force on an object based on the currentdensity through the object and the ambient magneticfield? Conceptually understand the properties of magneticmaterials, interpret the magnetization curve for amaterial, and the understand the consequences ofmagnetic saturation? Evaluate a static magnetic field at the boundarybetween two materials with different permeabilities? Solve magnetic circuits? Understand the relationship between and be able tocalculate magnetic field, magnetic flux, and magneticflux linkage? Unit 4: Electrodynamics? Basic electromagnetic wave propagation theory? Differentiate between conduction anddisplacement current and calculate conductioncurrent from the electric field? Determine whether a material is a conductor, low-loss dielectric, or neither.? Calculate or determine:? Phase and attenuation constants for a lossy EMwave? Intrinsic impedance of a medium given an EMwave?s electric and magnetic field amplitude? Direction of the electric field, magnetic field andPoynting vector for a propagating EM wave? Skin depth of an EM wave in a lossy medium? Average power density of a propagating EM wave? Amplitudes, power densities and angles forreflected and transmitted EM waves at a boundarybetween two media for arbitrary angle ofincidence and polarization (perpendicular orparallel)? For a given EM wave boundary interaction whetheror not a critical angle or Brewster?s angle exists? EM Wave?s polarization and any related parametersthat define the polarization",
      "Control and Autonomy"
    ]
  },
  {
    "course_code": "2110",
    "categories": [
      "Electrical Energy Systems",
      "Electrical and Power System",
      "Pre-requisites? PHYS 1200 or PHYS 1250? ECSE 2010",
      "Follow-up Courses? 4110? 4120? 4141? 4180",
      "This course introduces the major components of today?s power system such as transformers, electric machines, and transmission lines. Renewable energy sources and systems are discussed, including wind and solar energy. Integration of energy sources with the grid is addressed.",
      "core"
    ]
  },
  {
    "course_code": "2210",
    "categories": [
      "Microelectronics Technology",
      "Computer System Design",
      "Pre-requisites? PHYS 1200 or PHYS 1250? ECSE 2010",
      "Follow-up Courses? 4220 (recommended)? 4250? 4370",
      "An introductory survey of microelectronics technology emphasizing physical properties of semiconductors, device and circuit fabrication, semiconductor device operation. Topics include semiconductor crystals; energy bands; electrons and holes; dopant impurities; fabrication and operation of diodes, bipolar junction transistors, and field-effect transistors."
    ]
  },
  {
    "course_code": "2260",
    "categories": [
      "Computer Architecture, Networks, and Operating Systems",
      "Computer System Design",
      "Pre-requisites ? 2610 ? Combination and sequential logic design ? Boolean algebra ? Knowledge of binary number systems",
      "Follow-up Courses ? 4320 ? 4660 ? 4740 ? 4770",
      "? Learned Concepts ? 2660.1 Assembly language and programming ? 2660.2 Computer arithmetic ? 2660.3 Processor datapath and basic pipelining ? Basic operating system theory"
    ]
  },
  {
    "course_code": "2410",
    "categories": [
      "Signals and Systems",
      "Control and Autonomy",
      "Pre-requisites? ECSE 2010? 2010.1 Complex number algebra and phasors? 2010.2 Sketching and interpreting Bode plots? MATH 1010 (not listed)? Differentiation (Chain/quotient rules)? Integration (integration by parts)? MATH 2400 (not listed)? Solution of differential equations (1st,2nd order)",
      "Follow-Up Courses? 4090? 4440? Utilized skills? 2410.1 Laplace transform? 2410.2 Using transfer functions to describe LTIsystems? 4500? 4510? 4520? 4530? 4560",
      "? Developed Skills? 2410.1 Laplace transform? 2410.2 Using transfer functions to describeLTI systems? Fourier transform? Fourier series? System stability (root locus, Routh-Hurwitz)? MATLAB (further development from circuits?)? Understanding the basics of systems analysis? Frequency, time-frequency duals and analysis? Time-domain analysis of simple (1st and 2ndorder) systems"
    ]
  },
  {
    "course_code": "2500",
    "categories": [
      "Engineering Probability",
      "core",
      "? Pre-requisites? MATH 2400? Not needed (seconded)? Note from Rich: Math 2010 would be abetter prereq but I think we usedDiffEq for timing/template reasons",
      " Follow-up Courses? 4520? 4530? 4560? 4670? 4810? 4850",
      "? Learned Concepts? 2500.1 Discrete and continuous probabilitydensity functions? 2500.2 Joint random variables; Laws of largenumbers? 2500.3 Application of probability theory tostatistical analysis of data? Capability to have a formal understanding ofprobability/chance? Be able to analyze probability (discrete andcontinuous)? Have a general understanding of statisticaldecision-making"
    ]
  },
  {
    "course_code": "2610",
    "categories": [
      "Computer Components and Operations",
      "Computer System Design",
      "Pre-requisites ? CSCI 1100",
      "Follow-up Courses ? 4040 ? 4220 ? 4670 ? 4750 ? 4770",
      "? Learned Concepts ? 2610.1 Digital logic ? 2610.2 Finite state machine ? 2610.3 Hardware description language"
    ]
  },
  {
    "course_code": "2900",
    "categories": [
      "ECSE Enrichment Seminar",
      "core",
      "-",
      "-",
      "Learned Concepts ? Broader understanding of the societal impacts of engineering on addressing technical and sociological grand challenges in the world today (e.g., climate, water, diversity, equity, workforce development, business challenges, change management)"
    ]
  },
  {
    "course_code": "4030",
    "categories": [
      "Analog IC Design",
      "Electronics and Photons",
      "? Pre-requisites ? 2050 ? Basic understanding of electronics ? Active (transistors) and passive components (resistors and capacitors) ? Large and small signal models ? Circuit analysis techniques ? Mesh and loop equations ? Superposition, Thevenin and Norton?s equivalent circuits ? Basic device physics (are BRIEFLY reviewed) ? PN junctions ? MOSFET modes of operation (OFF, triode, saturation (active) ? Biasing of MOS transistors ? Small signal model of MOSFET",
      "? Learned Concepts ? learn design techniques of analog integrated circuits in standard CMOS technology ? different circuit architectures ? transistor sizing to achieve design goals ? how to bias an IC ? Apply analog IC design techniques by performing the electrical design and simulation of an operational amplifier OPAMP or analog circuit of similar complexity in an industrial environment (Cadence)"
    ]
  },
  {
    "course_code": "4040",
    "categories": [
      "Digital Electronics",
      "Electronics and Photons",
      "? Pre-requisites? 2050? Basic circuit analysis? Device electrical characteristics? SPICE simulator? 2610? Boolean logic",
      "? Learned Concepts? Basic MOSFET operating physicsand large-signal models? Digital circuit building blocks? Analysis and synthesis ofcombinational and sequentialMOS logic circuits"
    ]
  },
  {
    "course_code": "4050",
    "categories": [
      "Advanced Electronic Circuits",
      "Electronics and Photons",
      "? Pre-requisites? 2050? Understanding of non-idealoperational amplifiers, associatedanalysis (heavily reinforced in 4050)? Non-linear circuit analysis with diodes? Differences between BJT and FETtechnologies. ? Additional knowledge needed? 2010? Understanding of ideal operationalamplifier operation, associated analysis? Ability to analyze circuits",
      " Learned Concepts? Ability to? fully analyze the linear operation ofboth ideal and non-ideal operationalamplifier circuits? basic analysis of non-linear operationalamplifier circuits? understand error sources in op ampcircuits and apply/analyze as necessary? characterize noise in op amp circuits,both DC and AC? Determine op amp circuit stabilitycharacteristics and applycompensation techniques.? Identify important characteristics of opamps from their datasheets."
    ]
  },
  {
    "course_code": "4080",
    "categories": [
      "Semiconductor Power Electronics",
      "Electronics and Photons",
      "ECSE 2050",
      "ECSE 4130",
      "Special problems of semiconductor devices operating at high voltage and high current levels. Devices include p-i-n and Schottky diodes, bipolar junction transistors, power MOSFETs and thyristors. Topics include space charge limited current flow, micro plasmas, avalanche breakdown, junction termination, high-level injection, emitter crowding, double injection, second breakdown, triggering mechanisms, plasma propagation, switching and recovery characteristics. Introduction to the Insulated-Gate Bipolar Transistor."
    ]
  },
  {
    "course_code": "4090",
    "categories": [
      "Mechatronics",
      "Control and Autonomy",
      "Pre-requisites? 2410 or MANE 4500",
      "The synergistic combination of mechanical engineering, electronics, control engineering, and computer science in the design process. The key areas of mechatronics studied in depth are control sensors and actuators, interfacing sensors and actuators to a microcomputer, discrete controller design, and real-time programming for control using the C programming language. The unifying theme for this heavily laboratory-based course is the integration of the key areas into a successful mechatronic design."
    ]
  },
  {
    "course_code": "4110",
    "categories": [
      "Power Engineering Analysis",
      "Electrical and Power System",
      "ECSE 2110",
      "ECSE 4130",
      "AC steady-state analysis, three-phase networks, and complex power (brief review). Per-unit system. Practical transformer equivalent circuits. AC power transmission-lines: parameters; equivalent circuits; and steady-state operation. Power flow with transfer limits in balanced three-phase systems. Network power flow problem with solution by numerical methods. Symmetrical components: analysis including sequence networks for three-phase systems. Fault analysis."
    ]
  },
  {
    "course_code": "4120",
    "categories": [
      "Electromechanics",
      "Electrical and Power System",
      " Pre-requisites? 2110? Introduction to electrical equipment modeling andanalysis",
      "ECSE 4130",
      "Learned Concepts? Understand magnetic circuits from thefundamental principles such as Faraday?s law,Ampere?s Law and Gauss Law.? Using first principles, derive the basicconcepts and methods used forElectromechanics.? Understand the principles ofelectromechanical energy conversion used inelectric machines, actuators etc.? Construct mathematical models fordetermining the steady state performance ofvarious electric machines (both AC and DC)using first principles.? Understand the role of electric machines inthe broader applications including, industrial,residential and electric propulsion.? Be able to model electric machines usingMATLAB or equivalent packages."
    ]
  },
  {
    "course_code": "4130",
    "categories": [
      "EPE Lab",
      "Electrical and Power System",
      "Pre-requisites? 1 of:? 4080? 4110? 4120? Understanding of principles ofelectromagnetic fields,transformers, motors, DC/DC andDC/AC inverters",
      "? Learned Concepts? Hands-on experience of building,debugging and evaluation ofpower system components andcircuits. The course will providethe experimental study of thephysical phenomena andcharacteristics of magneticcircuits, transformers, electricmachines, rectifiers, DC/DCconverters, and inverters.H"
    ]
  },
  {
    "course_code": "4141",
    "categories": [
      "Renewable Power Generation",
      "Electrical and Power System",
      "ECSE 2110",
      "Generation of electric power from renewable sources and its integration into the power grid. Topics include fundamentals of photovoltaic and wind energy; power converters and their control for renewable energy conversion and grid integration; solar power plants, solar inverters, and their control; wind turbines based on synchronous generators, wind turbines based on doubly-fed induction generators (DFIG), wind power plants, and offshore wind; operation and control of power systems with renewables."
    ]
  },
  {
    "course_code": "4170",
    "categories": [
      "Modeling and Simulation for Cyver-ph",
      "Control and Autonomy",
      "Pre-requisites? MATH 2010? Student is able to solve directional derivatives, maximaand minima, integrals, div and curl.? Student is able to perform computations using matrixalgebra and systems of linear equations, vectors? Student is able to calculate eigenvectors andeigenvalues.? MATH 2400? Student is able to solve first-order differential equations,second-order linear equations.? Student is able to perform computations of eigenvaluesand eigenvectors of matrices, systems of first-orderequations.? Student is able to determine stability and qualitativeproperties of nonlinear autonomous systems.? Student is able to compute Fourier series.?",
      "Learned Concepts? Student will be able to perform modeling and simulationof cyber-physical systems through object-orientedequation-based computer languages and software tools.? Student will be able to apply formalisms for continuous,discrete, and finite state machines for modeling purposes.? Student will be able to apply and judge the output ofsimulation methods through numerical solution ofdifferential-and-algebraic higher-and-varying indexsystems of equations with time and state event eventhandling.? Student will be able to create composing reusable modelarchitectures, templates, interfaces and data managementfor model variants.? Student will be able to understand and apply modeldeployment in heterogeneous environments using modelexchange, co-simulation and real-time simulationtechniques."
    ]
  },
  {
    "course_code": "4180",
    "categories": [
      "Industrial Power System Design",
      "Electrical and Power System",
      "ECSE 2110",
      "???"
    ]
  },
  {
    "course_code": "4220",
    "categories": [
      "VSLI Design",
      "Computer System Design",
      "Pre-requisites? 2050? CMOS device I-V characteristics? Vt equation? Schematic modeling and simulation? Vsb effects? 2210 (recommended)? IC fab processing steps for CMOS devices? Use of masks? Understanding of 3D structure of devices? 2610? Basic logic operations? Boolean logic arithmetic? Combinational and sequential circuits? Duality? Simple state machines",
      "Learned Concepts? Design transistor-level static and dynamic CMOSgates, transmission gate logic, layout forunbroken diffusion strips using Logic Graphs &Euler Paths? Analyze speed and power, understand trade-offs,estimate switching speed? Minimize delays through optimized sizing usinglogical effort calculations? Low power design, activity factor, minimizepower (static & dynamic) in circuit configurationand device parameters? Combinational and Sequential circuit timinganalysis? Understand and analyze performancedegradation from timing skew & jitter? SRAM, DRAM, ROM, EPROM memory designs? IC design for fabrication using EDA (Cadence,Mentor) tools, rudimentary experience with LVS(layout vs. schematic), DRC (fab design rulecheck). PEX (parasitic extraction for accurateperformance simulation), and cleaned-up layouts"
    ]
  },
  {
    "course_code": "4250",
    "categories": [
      "IC Process and Design",
      "Computer System Design",
      "Pre-requisites? 2210? Si material properties? Diode and MOS devicecharacteristics",
      "Learned Concepts? Generation of process steps for ICfabrication? Process simulation"
    ]
  },
  {
    "course_code": "4310",
    "categories": [
      "Fundamentals of RF/Microwave Engineering",
      "Electronics and Photons",
      "Pre-requisites? 2050? understanding of transistorsfundamentals (dc bias, small signalmodels)",
      "Learned Concepts? Model RF passive components? Design matching and biasingnetworks operating over a specificfrequency range? Analyze and design RF circuitssuch as couplers, powercombiners/dividers, andamplifiers.? Use of Smith chart and use ofmicrowave CAD tools such asKeysight ADS"
    ]
  },
  {
    "course_code": "4320",
    "categories": [
      "Advanced Computer Systems",
      "Computer System Design",
      "Pre-requisites? 2660 or CSCI 2500? CPU pipelining? Cache and memory? Operating system",
      "Learned Concepts? Obtain a deeper understanding ofadvanced computer system hardwarestack, including CPU/GPU architecture,cache and memory, and data storage? Obtain a deeper understanding of the keysoftware system design concepts,including consistency, concurrency,transaction, and indexing? Improve C/C++ programming skills via aset of programming-intensive coursedesign projects? Strengthen the ability to carry outindependent research, and gainexperience on making technicalpresentations"
    ]
  },
  {
    "course_code": "4370",
    "categories": [
      "Intro to Optoelectronics",
      "Electronics and Photons",
      "Pre-requisites? 2210? PN junction fundamentals",
      "? Learned Concepts? Demonstrate an ability to understand and analyze thefundamentals of wave confinement and propagation inpassive photonic devices such as optical cavities,optical filters, waveguides and optical fibers.? Apply cavity theory and waveguide equations tocalculate optical cavity Q-factor, free-spectrum range,single mode condition of waveguides and optical fibers.? Demonstrate an ability to explain the workingprinciples of light emitting diodes, laser diodes,photodetectors, photovoltaic devices and opticalmodulators.? Demonstrate an ability to calculate the basic devicecharacteristics such as photodetector responsivity,quantum efficiency, laser diode linewidth, thresholdcondition, light emitting diode efficiency.? Demonstrate the understanding of the physics ofoptical polarization, ordinary and extraordinary wavesin birefringent materials, phase retardation plates,liquid crystal display, Pocket effect and Kerr effect,intensity and phase modulators, and complexoptoelectronic systems such as light detection andranging (LiDAR) systems."
    ]
  },
  {
    "course_code": "4380",
    "categories": [
      "Fundamentals of Solid State Lighting Systems",
      "Electronics and Photons",
      "Pre-requisites? PHYS 1200 or PHYS 1250? 2050",
      "Learned Concepts? Fundamental understanding ofsolid state lighting systems andapplications, including basics ofLED design, manufacturing,thermal management, optics,control systems, lightmeasurement basics andapplications in general lighting, UVgermicidal disinfection,horticulture lighting, and displaytechnologies"
    ]
  },
  {
    "course_code": "4440",
    "categories": [
      "Control Systems Engineering",
      "Control and Autonomy",
      "Pre-requisites? MATH 2400 (not listed pre-req)? M2400.1 Solving linear differentialequations with initial conditions? 2010 (not listed pre-req)? 2010.1 Complex number algebra andphasors? 2010.2 Sketching and interpretingBode plots? 2410 or MANE 4500? 2410.1 Laplace transform? 2410.2 Using transfer functions todescribe LTI systems",
      " Follow-Up Courses? 4760? Used skills? 4440.1 Lead and lag compensatorsdesign",
      "Developed Skills? 4440.1 Lead and lag compensatorsdesign? Design and analyze dynamic modelsof systems including mechanical andelectrical systems.? Understand the basic principles offeedback, including disturbancerejection, robustness to parameters,and tracking accuracy.? Apply feedback control design andanalysis techniques, including root-locus, frequency response, and state-space.? Build and analyze models and designfeedback controls in MATLAB thatachieve design requirements."
    ]
  },
  {
    "course_code": "4480",
    "categories": [
      "Robotics I ",
      "Control and Autonomy",
      "Pre-requisites? MATH 2010? M2010.1 Vector/matrix algebra? M2010.2 Basic principles ofoptimization? M2010.3 Differentiation up to 2ndorder? M2010.4 Solving systems of linearequations? MATH 2400? Solution of 2nd order ODE",
      "Follow-Up Courses? 4490? Used skills? 4480.1 Forward kinematicsformulation? 4480.2 Jacobian matrix formulation",
      "Developed Skills? 4480.1 Forward kinematicsformulation? 4480.2 Jacobian matrix formulation? Inverse kinematics solution methods? Basic path planning: linear inCartesian or joint space? Intro to PID control? Camera Calibration? Intro to rigid body dynamics:application to manipulator"
    ]
  },
  {
    "course_code": "4490",
    "categories": [
      "Robotics II",
      "Control and Autonomy",
      " Pre-requisites? 4480 (not listed pre-req)? 4480.1 Forward kinematicsformulation? 4480.2 Jacobian matrix formulation",
      "Developed Skills? Basic usage/functionality of ROS? Definition of mobile robotkinematics for various wheel types? Understanding of SLAM theory? Use and theory of Kalman Filters? Recognition of multiple pathplanning algorithms(use/limitation/function)? Basic understanding of multi-robotcontrol concepts? Evaluation of grasp stability forfrictionless and friction contacts "
    ]
  },
  {
    "course_code": "4500",
    "categories": [
      "Distributed Systems and Sensor Networks",
      "Communications and Networking",
      "ECSE 2410",
      "Recent developments in systems, sensors, communications, and networking technologies enable the development of large-scale distributed systems incorporating many individual nodes. This course takes an algorithmic approach to distributed systems for sensor fusion, localization and tracking, distributed robotics and sensor-based control. It also presents the basic principles of sensor node architectures and wireless sensor networks. Applications include environmental monitoring, biomedical systems, and security-related tracking problems."
    ]
  },
  {
    "course_code": "4510",
    "categories": [
      "Digital Control Systems",
      "Control and Autonomy",
      "ECSE 2410 or MANE 2500",
      "Sampling, quantization, and reconstruction of signals. Mathematical tools used in the modeling, analysis, and synthesis of discrete-time control systems. Analysis tools include? z-transforms, difference equation solutions, state variables, and transfer function techniques. Design tools digital PID controller, root locus, bilinear transformations, compensation techniques and full-state feedback. Applications to sampled-data control."
    ]
  },
  {
    "course_code": "4530",
    "categories": [
      "Digital Signal Processing",
      "Communications and Networking",
      "? Pre-requisites? MATH 2010? M2010.1? 2410? 2410.2? 2410.3? 2500? Understanding and usage ofcontinuous random variables",
      "Learned Concepts? Understanding of the use andapplication of z-transform anddiscrete-time Fourier transform? Understanding of discrete timesampling theory and amplitudequantization? Understanding of the design andimplementation of FIR and IIRdigital filters? Understanding of adaptive digitalfilter, signal estimation, andprediction"
    ]
  },
  {
    "course_code": "4540",
    "categories": [
      "Intro to Image Processing",
      "Control and Autonomy",
      "Pre-requisites? MATH 2010? Double integration? Basic matrix algebra? 4530? Discrete-time Fourier Transform (DTFT)? Frequency response? Filtering? aliasing",
      "An introduction to the field of image processing, covering both analytical and implementation aspects. Topics include the human visual system, cameras and image formation, image sampling and quantization, spatial- and frequency-domain image enhancement, filter design, image restoration, image coding and compression, morphological image processing, color image processing, image segmentation, and image reconstruction. Real-world examples and assignments drawn from consumer digital imaging, security and surveillance, and medical image processing."
    ]
  },
  {
    "course_code": "4560",
    "categories": [
      "Modern Communication Systems",
      "Communications and Networking",
      "Pre-requisites? 2410? Understanding of Fourier transformsand frequency domain analysis? 2500? Understanding of random variablesand their distributions?",
      "ECSE 4760",
      "? Learned Concepts? Knowledge of how signals aretransmitted over wired andwireless links? Knowledge of communicationprinciples underlying WiFi andcellular communications"
    ]
  },
  {
    "course_code": "4620",
    "categories": [
      "Computer Vision for Visual Effects",
      "Control and Autonomy",
      "Pre-requisites? MATH 2010? CSCI 1200",
      "This course describes the computer vision problems that underlie modern visual effects in movies, in which original video footage is transformed or augmented to create fantastic, yet plausible environments. The course provides a critical overview of the important literature for several problem categories, describing \"under-the-hood\" concepts and algorithms in mathematical detail. In many cases, the relevant academic research is only a few years old and has only recently been applied to movies, TV shows, and commercials."
    ]
  },
  {
    "course_code": "4630",
    "categories": [
      "Lasers and Optical Systems",
      "Electronics and Photons",
      "? PHYS 2620 (recommended)? "
    ]
  },
  {
    "course_code": "4640",
    "categories": [
      "Optical Communications and Integrated Optics",
      "Electronics and Photons",
      "? PHYS 2620 ? "
    ]
  },
  {
    "course_code": "4660",
    "categories": [
      "Internetworking of Things",
      "Communications and Networking",
      "Pre-requisites? 1 of:? CSCI 2500? 2660? Knowledge of different parts of acomputer system? Binary arithmetic",
      "Learned Concepts? Knowledge of wirelesscommunication technologies? Knowledge of IoT communicationprotocols? Knowledge IoT security principles? Implementation of IoT application"
    ]
  },
  {
    "course_code": "4670",
    "categories": [
      "Computer Communication Networks",
      "Communications and Networking",
      "? Pre-requisites? Recommended? 2500? Basic understanding of what aprobability distribution is? Calculating mean and variance of agiven distribution? 2610 or CSCI 2500? Knowledge of different parts of acomputer system? Binary arithmetic",
      "? Learned Concepts? Knowledge of computercommunication protocols for datatransfer through the Internet? Understanding of the working ofInternet applications such as Web,Email, File transfer? Network programming fordeveloping client-serverapplications over the Internet"
    ]
  },
  {
    "course_code": "4720",
    "categories": [
      "Solid State Physics",
      "Electronics and Photons",
      "Pre-requisites? PHYS 2220",
      "An introduction to theoretical and experimental solid-state physics. Wave mechanics in the perfect crystal. X-rays, electrons, and phonons. Electrical properties of metals and semiconductors. Qualitative treatment of lattice defects."
    ]
  },
  {
    "course_code": "4740",
    "categories": [
      "Applied Parallel Computing for Engineers",
      "core",
      "Pre-requisites? 2660",
      "Engineering techniques for parallel processing. Knowledge and hands-on experience in developing applications software for processors on inexpensive widely-available computers with massively parallel computing resources. Multi-thread shared memory programming with OpenMP and NVIDIA GPU multicore programming with CUDA and Thrust. The use of NVIDIA gaming and graphics cards on current laptops and desktops for general purpose parallel computing using Linux."
    ]
  },
  {
    "course_code": "4750",
    "categories": [
      "Computer Graphics",
      "Computer System Design",
      "Pre-requisites? 1 of:? CSCI 2500? 2610",
      "Introduction to Interactive Computer Graphics, with an emphasis on applications programming. Objects and viewers, and the synthetic camera model. Graphics architectures, the graphics pipeline, clipping, rasterization, and programmable shaders. Input and interaction. Geometric objects, homogeneous coordinates, and transformations. Viewing, hidden surface removal, frame and depth buffers, compositing, and anti-aliasing. Shading, light and materials, texture mapping, ray tracing, and radiosity. Intellectual property concerns. Extensive programming with the OpenGL API and C++."
    ]
  },
  {
    "course_code": "4760",
    "categories": [
      "Real-time Application in Control Communication",
      "Control and Autonomy",
      "? Pre-requisites? 1 of:? 4560? 4440? 4440.1",
      "Experiments and lectures demonstrate the design and use of microcomputers as both decision tools and on-line real-time system components in control and communications. Topics include the basic operations of microcomputers, data I/O, analog and digital process control, voice processing, digital filter design, digital communication, and optimal LQR control."
    ]
  },
  {
    "course_code": "4770",
    "categories": [
      "Computer Hardware Desirgn",
      "Computer System Design",
      "? Pre-requisites? 2610? 2610.1 Digital logic? 2610.2 Finite state machine? 2610.3 Hardware descriptionlanguage? 2660 (not listed as prereq)? 2660.1 Assembly language andprogramming? 2660.2 Computer arithmetic? 2660.3 Processor datapath and basicpipelining",
      "Follow-up Courses? 4780",
      " Learned Concepts? Design and implementation ofsimple CPU core? Instruction set architecture? Microarchitecture? Memory systems"
    ]
  },
  {
    "course_code": "4780",
    "categories": [
      "Advanced Computer Hardware Design",
      "Computer System Design",
      "Pre-requisites? 4770? Design and Implementation ofsimple CPU core? Instruction set architecture? Microarchitecture? Memory systems",
      "? Learned Concepts? Modern/advanced CPUmicroarchitecture? Advanced cache design? General-purpose GPU architecture? Memory and interconnect design? Domain-specific architectures forAI/ML"
    ]
  },
  {
    "course_code": "4790",
    "categories": [
      "Microprocessor Systems",
      "Electronics and Photons",
      "Pre-requisites? ENGR 2350? Basic understanding and skills in writingC language programming? Understanding of the interface betweenfirmware and hardware (insidemicrocontroller vs. outside)? Basic digital circuit analysis.? Ability to troubleshoot/de bug/verifyembedded prototypes? CSCI 1200 (strongly recommend)? More in depth understanding of C/C++language.? Ability to understand and use C structsand pointers. Other needed knowledge? CSCI 1100? Ability to understand and implement acomputer program.? Understand/use basic programmingstructures, such as conditionals, loops,functions.",
      "Learned Concepts? Ability to? create complex embedded programmings? read the datasheet(s) for devices andimplement system functionality usingdevice capabilities? understand and use more complicatedmicroprocessor/microcontrollercapabilities; such as DMA, USB, etc.? Improved ability totroubleshoot/debug/verify embeddedprototypes"
    ]
  },
  {
    "course_code": "4810",
    "categories": [
      "Probabilistic Graphical Models",
      "Control and Autonomy",
      "Pre-requisites? 2500 or ENGR 2600",
      "This course covers topics related to learning and inference with different types of Probabilistic Graphical Models (PGMs). It also demonstrates the application of PGMs to different fields. The course covers both directed and undirected graphical models, both parameter and structure learning, and both exact and approximated inference methods."
    ]
  },
  {
    "course_code": "4840",
    "categories": [
      "Intro to Machine Learning",
      "Control and Autonomy",
      "Pre-requisites? MATH 2010? 2500",
      "A broad introduction to statistical machine learning. Topics include supervised learning: generative/discriminative learning, parametric/non-parametric learning, neural networks, support vector machines; unsupervised learning: clustering, dimensionality reduction, kernel methods; learning theory: bias/variance tradeoffs, practical advice; online learning and reinforcement learning. Recent applications of machine learning, such as to data mining, robot navigation, speech recognition, image processing, and signal processing."
    ]
  },
  {
    "course_code": "4850",
    "categories": [
      "Intro to Deep Learning",
      "Control and Autonomy",
      "? Pre-requisites? MATH 2010? CSCI 1200? 2500",
      "Deep learning fundamentals and applications in artificial intelligence. Topics include machine learning foundation, linear regression and classification, deep neural networks, convolutional neural networks, recurrent neural networks, generative adversary neural networks, Bayesian neural networks, deep Boltzmann machine, deep Bayesian networks, and deep reinforcement learning."
    ]
  },
  {
    "course_code": "4900",
    "categories": [
      "Multidisciplinary Capstone Design",
      "core",
      "Pre-requisites? ENGR 2050",
      "A capstone design experience that engages students from biomedical, computer and systems, electrical, industrial, materials, and mechanical engineering on teams in an open-ended engineering design problem in preparation for professional practice. With the guidance of a multidisciplinary team of faculty members and instructional support staff, students apply knowledge and skills from prior coursework. This is a communication-intensive course."
    ]
  },
  {
    "course_code": "ENGR 2350",
    "categories": [
      "Enmbedded Control",
      "Control and Autonomy"
    ]
  }
  ];

  // API Key - Use the same one from your dart-define or hardcode for testing
  //const String apiKey = "AIzaSyCV9XPKYPOT-bfEWsAVfXlCZh5rTd_Hdic"; 
  //const String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

try {
    // 3. Talk to Gemini directly from the app
    final content = [
      Content.text('''
        You are Luxi, a project advisor. 
        Use this course data: ${jsonEncode(data)}
        
        User Request: $userInput
      ''')
    ];

    final response = await _model.generateContent(content);
    return response.text ?? "I couldn't come up with anything.";
    
  } catch (e) {
    return "AI Error: $e";
  }
}