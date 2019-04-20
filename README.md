# Codebreaker

Simple two-player mastermind-style game. The game works by allowing the master player to first set a combination of three 
LEDs from a total of six possible LED choices. Thereafter, a secondary player inputs combinations and tries to guess the master
combination through an unlimited amount of trials. If the secondary player enters the correct LED colours, but they are in
incorrect order, the output LEDs will flash. If the player enters the correct LED choice and position, the output LED will stay
solid. A simple celebration routine where all the LEDs will light and flash upon breaking the code.

## Usage

The program was developed for the ATMega328P chip found on the Arduino Uno. You may use any environment you wish to run the
source code, however this program was built on Atmel Studio.

## Circuit

The hardware makes use of an Arduino Uno, two push-buttons, ten LEDs, and various resistors.

<img width="468" alt="image" src="https://user-images.githubusercontent.com/19896167/56459609-e8ca6080-6363-11e9-8ee3-77e4471f5b68.png">
