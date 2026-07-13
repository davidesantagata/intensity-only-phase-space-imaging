# Single-Frequency Intensity-Only Target Localization using Phase-Space Deconvolution

This repository contains the MATLAB implementation of the phase-space deconvolution framework proposed for single-frequency intensity-only target localization.

The method enables target reconstruction from intensity-only measurements by exploiting the relationship between Mark's physical spectrum and the Wigner distribution in phase space. The proposed approach transforms the nonlinear intensity-only inverse problem into a linear reconstruction problem through phase-space deconvolution techniques.

The repository provides the MATLAB codes used for numerical simulations, reconstruction examples, Monte Carlo error analysis, and detection performance evaluation.

---

## Repository structure

```
.
├── main.m                         Single reconstruction example
├── main_error.m                   Monte Carlo error analysis
├── main_ROC.m                     Monte Carlo detection and ROC analysis
│
├── systemForward.m                Forward scattering model
├── windowingInversion.m           Window-based phase-space inversion
├── WienerInversion.m              Wiener-based phase-space inversion
├── associatePeaks.m               Peak association utility
│
├── README.md
└── LICENSE
```

---

## Requirements

The code requires:

- MATLAB (tested with recent versions)
- Signal Processing Toolbox (required for noise generation functions)

---

## Description

The simulation workflow includes the following steps:

1. Definition of the electromagnetic, illumination, and beam parameters.
2. Generation of synthetic single-frequency intensity-only measurements.
3. Computation of Mark's physical spectrum from the measured intensity data.
4. Phase-space marginalization through the Wigner distribution framework.
5. Target reconstruction through phase-space deconvolution using:
   - Window-based inversion.
   - Wiener-based inversion.

---

## How to run

The repository includes three main scripts depending on the desired analysis.

### 1. Single reconstruction example

Run:

```matlab
main
```

This script generates synthetic intensity-only measurements and performs target reconstruction using the proposed phase-space deconvolution framework.

The reconstruction results obtained with the window-based and Wiener-based inversion methods are displayed and compared.

---

### 2. Monte Carlo error analysis

Run:

```matlab
main_error
```

This script performs a Monte Carlo analysis to evaluate the robustness of the reconstruction methods under noisy measurements.

The statistical analysis includes the computation of reconstruction error metrics over multiple noise realizations, providing the mean and standard deviation of the reconstruction error.

---

### 3. Detection performance analysis

Run:

```matlab
main_ROC
```

This script performs a Monte Carlo-based detection analysis.

The following performance metrics are evaluated:

- Probability of detection as a function of the detection threshold.
- False alarm rate as a function of the detection threshold.
- Receiver Operating Characteristic (ROC) curves.

---

## Reference

If you use this code, please cite:

```
D. Santagata, G. Gradoni, and S. Solimene,
"Single-Frequency Intensity-Only Target Localization using Phase-Space Deconvolution."
```

---

## Authors

Associated scientific work:

**Davide Santagata**  
**Giuseppe Gradoni**  
**Salvatore Solimene**

Code implementation:

**Davide Santagata**

---

## License

This project is released under the MIT License.
