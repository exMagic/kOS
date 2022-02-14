wait 0.2.
global partlist is SHIP:PARTSNAMED("hinge.04").

SET step TO "PID".
rcs on.
runstep("PID",step_PID@).
function runstep {
	parameter stepName.
	parameter stepFunction.
	if(step=false){
		SET step TO stepName.
	}
	if(step=stepName){
		UNTIL step = false {			
			stepFunction:call(). //call main step function
		}
	}
}


function step_PID2 {
    declare global myThrottle to .5.
    lock throttle to myThrottle.

    // up, but keeping the north facing direction
    lock steering to lookdirup(up:forevector, heading(180, 0, 0):forevector).

    stage.

    declare local targetAlt to 100.
    //print "Starting pid control. Targeting " + targetAlt + "m.".

    declare local kP to .15.
    declare local kI to .025.
    declare local kD to .2.

    //print "pidloop(" + kP + ", " + kI + "," + kD + ", .1, 1).".
    // declare local pid to pidloop(kP, kI, kD, 0.1, 1).
    declare local pid to pidloop(kP, kI, kD).
    set pid:setpoint to targetAlt.

    until false {
    set myThrottle to pid:update(time:seconds, alt:radar).
    //print "alt: " + round(ship:altitude, 2).
    wait .05.
    printComp(). 
    }

}


print "Exiting".


function step_PID {
    SetFlapsVac().
    printComp(). 
}

function SetFlapsVac{ 
    set er to 90 - VANG(ship:facing:STARVECTOR,ship:up:vector).
    set er2 to 0.

    SET Kp TO 2.
    SET Ki TO 2.
    SET Kd TO 2.
    SET PID TO PIDLOOP(Kp, Ki, Kd).
    SET PID:SETPOINT TO 0.



    SET er2 TO PID:UPDATE(TIME:SECONDS, er).
    WAIT 0.001. 
    


    set FLAngle to 90 + er2.
    set FRAngle to 90 - er2. 

    Flap_FR_Set(FRAngle).
    Flap_FL_Set(FLAngle).
}


function printComp{
    clearscreen.
    print "er              |" + er.
    print "er2             |" + er2.
    print "FLAngle         |" + FLAngle.
    print "FRAngle         |" + FRAngle.
    print "str to up       |" + VANG(ship:facing:STARVECTOR,ship:up:vector).

    // print "myThrottle      |" + myThrottle.
    // print "alt:radar       |" + alt:radar.
    //wait 0.05. 
}

function Flap_FR_Set {
    parameter num.
    partlist[0]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", num).//top right
    //SHIP:PARTSNAMED("SS.21.FF.R")[0]:GETMODULE("ModuleTundraControlSurface"):SETFIELD("Deploy Angle",num).
}

function Flap_FL_Set {
    parameter num.
    partlist[1]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", num).//top right
    
    //SHIP:PARTSNAMED("SS.21.FF.L")[0]:GETMODULE("ModuleTundraControlSurface"):SETFIELD("Deploy Angle",num).
}
