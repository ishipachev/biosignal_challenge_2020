# Biosignal Challenge 2020 (CVUT)


Link to the event description:

http://sami.fel.cvut.cz/biosignalchallenge2020/

## About

This small repot designed to solve biosignal challenge described in the link above. Shortly: the challenge is to cound amount of syllabuses and length of speech for kids of different age. At the end it should help to calculate Articulation rate.

### Articulation rate (copy paste from challenge webpage)
Articulation rate (AR) is a prosodic feature that indicates the number of spoken speech units per time. It is typically measured during connected speech where all types of pauses including silence, respiration and hesitations (such as /ah/, /um/, etc.) are excluded. Therefore, the articulation rate is mainly viewed as a representation of speech motor control since the linguistic effects are reduced.

Most researchers agree that AR can be affected by certain variables, which includes the length of utterance, locus of the word or phrase in the sentence and speaking context as well as speaking task such as reading, picture description, spontaneous speech, etc.

Different studies use different metrics to quantify AR. The most commonly used metrics are word per minute (WPM), syllable per second (SPS) and phoneme per second (PPS). The most suitable metric for AR estimation is SPS since syllables can be detected more easily than words or phonemes.

The goal of the Biosignal Challenge 2020 is to use the computing environment MATLAB to develop an algorithm for AR estimation in human speech signals by detecting the number of syllables (NOS) and measuring the duration of fluent speech (DFS), which requires excluding all types of pauses in each utterance.

## How to run

### Network train
Go into *detect_speech* or *detect_syls* directory. Run setup.m in the folder to configure path.

### Detection on Biosignal Challenge 2020 contest files
Go into *runFolder* directory. Put all .wav files there. Run *test.p* file.


### Params
Check configuration file *loadSpeechParams* or *loadSylsParams* and all related paths in it. Next parameters should be set according labeled data and sound files:
* params.wavsFolder
* params.GTPath
* params.tgFolder
* params.tgTierName
* params.tgIntervalName

Params files also include all configuration parameters, including options for feature extractor and layers configuration. After each training they will be saved next to all checkpoints.

Splitting labeled datased defined by *params.trnProportion* and *params.trnNames* + *params.valNames*. *params.trnProportion* is used to devide labeled set on train and validation portions, but if some files named manually through usage of options *params.trnNames* or *params.valNames* they will be added to proportionally devided set.
To avoid proportional devision and rely only on written filenames, set *params.trnProportion* to zero

## Validate by running task.p

To validate result pick the best network from *checkpoint* folder. Put this network checkpoint (it is a net itself) into *net* folder with *trainOpt* file. This network and options will be used to evaluate result on all files by testing script. Also put all .wav files into runFolder. It is necessarily for running test.p script. 
Just run test.p at the end.


## Data

Put all .wav files inside *data/wavs* folder in the project's root. They are .gitignored by default, so this step should be done manually.
To run test.p they also should be in runFolder.

## Toolboxes used
* audio_system_toolbox
* neural_network_toolbox
* signal_toolbox
* statistics_toolbox


## Authors
[Yeva Prysiazhniuk](https://www.linkedin.com/in/yeva-prysiazhniuk/) & [Ilia Shipachev](https://www.linkedin.com/feed/)


## Biblio links
* Hendrik Purwins, Bo Li, Tuomas Virtanen, Jan Schlüter, Shuo-yiin Chang, Tara Sainath, „Deep Learning for Audio Signal Processing,“ JOURNAL OF SELECTED TOPICS OF SIGNAL PROCESSING, p. 06–219, 2019.
* Huy Phan, Philipp Koch, Fabrice Katzberg, Marco Maass, Radoslaw Mazur and Alfred Mertins, „Audio Scene Classification with Deep Recurrent Neural Networks,“ INTERSPEECH, 2017.
* Federico Colangelo, Federica Battisti, Alessandro Neri, Marco Carli, „CONVOLUTIONAL RECURRENT NEURAL NETWORK FOR AUDIO EVENTSCLASSIFICATION,“ Detection and Classification of Acoustic Scenes and Events, 2018.
* Kisler, T. and Reichel U. D. and Schiel, F., „Multilingual processing of speech via web services,“ Computer Speech & Language, sv. 45, p. 326–347, 2017.
* Klessa, K., Karpiński, M., Wagner, A., „Annotation Pro – a new software tool for annotation of linguistic and paralinguistic features.,“ Proceedings of the Tools and Resources for the Analysis of Speech Prosody (TRASP) Workshop, pp. 51-54, 2013.
* Bořil, T., & Skarnitzl, R., „Tools rPraat and mPraat,“ Text, Speech, and Dialogue, p. 367–374, 2016.
* I. The MathWorks, MATLAB and Audio Toolbox Release 2020a, Natick, Massachusetts, United States, 2020.
* Sepp Hochreiter, Jürgen Schmidhuber, „Long short-term memory,“ Neural Computation, sv. 9, č. 8, p. 1735–1780, 1997.
* Alec Wright, Eero-Pekka Damskägg, and Vesa Välimäki, „REAL-TIME BLACK-BOX MODELLING WITH RECURRENT NEURAL NETWORKS,“ v Proceedings of the 22nd International Conference on Digital Audio Effects , Birmingham, UK, 2019.
* M. Inc., „Classify Sound Using Deep Learning - MATLAB & Simulink,“ 2020. [Online]. Available: 
https://www.mathworks.com/help/audio/gs/classify-sound-using-deep-learning.html.
