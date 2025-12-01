# 🚦 T-Intersection Traffic Controller (Verilog FSM)
## Project Summary
This project demonstrates the design and simulation of a digital traffic light controller for a complex T-intersection, implemented entirely in Verilog HDL. The design utilizes a Finite State Machine (FSM) with four distinct modes, synchronized by a custom-built structural counter to manage varying traffic durations and prioritize pedestrian safety via a dedicated interrupt. The intersection joins three roads (A, B, C) as well as a pedestrian area, as shown below.

<div align = "center">
<img width="592" height="367" alt="image" src="https://github.com/user-attachments/assets/5651e41e-9c4a-4982-a06c-08f102aaa38a" />
</div>

## ⚙️ Core Design Architecture

The controller consists of two main modules: the **Traffic Controller FSM** and a structurally-modeled **5-bit Synchronous Counter**.

### 1. Finite State Machine (FSM)

The FSM cycles through four distinct modes, with transition logic based on the counter state and the external pedestrian input (I). The normal sequence is **Mode 1 → Mode 2 → Mode 3**.

When the pedestrian button (I) is pressed, the FSM completes the current mode's cycle and transitions immediately to **Mode 0** (Pedestrian Crossing) before resuming the normal sequence (Mode 1).

State Diagram:

<div align = "center">
<img width="745" height="720" alt="image" src="https://github.com/user-attachments/assets/34d959da-0d64-4dcc-8324-768f720c578c" />
</div>

### 2. Structural Counter

The timing requirements (up to 30 seconds) necessitate a custom counter. This component was designed structurally using five instantiated **JK Flip-Flops** and logic gates to ensure a synchronous count. This structural approach meets the design requirement and highlights low-level digital circuit understanding.

Counter Schematic:

<div align = "center">
<img width="1156" height="438" alt="image" src="https://github.com/user-attachments/assets/a56482ee-04b1-4a78-a5fb-c1298f52b679" />
</div>

## 🚦 Traffic Modes & Timing
The system operates on a 1 Hz clock. All light signals are simplified (1 for Green/ON, 0 for Red/OFF).
| Mode | Duration | Light Status (A1, A2, B, C) | Description |
| :--- | :--- | :--- | :--- |
| **Mode 1** | 30s | `1001` (A1=G, C=G) | Road A (Straight) and Road C traffic flow. |
| **Mode 2** | 10s | `1100` (A1=G, A2=G) | Road A (Straight and Left Turn) traffic flow. |
| **Mode 3** | 20s | `0010` (B=G) | Road B traffic flow (Left and Right). |
| **Mode 0** | 30s | `0000` (All Red) | **Pedestrian Crossing Time** (Triggered by input `I=1`). |

## 💻 Code & Verification
The project includes two essential testbenches to verify functionality:

### 1. Normal Operation (No Interrupt)
- Test Scenario: (I) is held at 0.
- Verification: Confirms the continuous cycle of Mode 1 (30s) → Mode 2 (10s) → Mode 3 (20s) → Mode 1...

### 2. Pedestrian Interrupt
- Test Scenario: (I) is set to 1 during Mode 2.
- Verification: Confirms that the system completes Mode 2, enters Mode 0 for 30s, and then correctly resumes the normal cycle starting at Mode 1.

### Terminal Output Snippet (Pedestrian Scenario):
```text
Time=2  | Mode=1 | Button(I)=0 | Lights: A1=1 A2=0 B=0 C=1  (30s)
Time=62 | Mode=2 | Button(I)=1 | Lights: A1=1 A2=1 B=0 C=0  (10s, button pressed)
Time=82 | Mode=0 | Button(I)=0 | Lights: A1=0 A2=0 B=0 C=0  (30s, Pedestrian Mode)
Time=142| Mode=1 | Button(I)=0 | Lights: A1=1 A2=0 B=0 C=1  (Resumes normal cycle)
```
*Project completed by Albert Saman (me) and Hussam Dawood (my lab partner) for Digital Logic Lab, Spring 2024.*
