function printComp{
    clearscreen.
    //print "isDryTest            |" + isDryTest.
    print "step:                |" + step.
    print "ship:VERTICALSPEED   |" + ship:VERTICALSPEED.
    print "ship:altitude        |" + ship:altitude.
    print "x                    |" + VANG(ship:facing:starvector,Vb).    
    print "x2                   |" + VANG(ship:facing:forevector,Va). 
    print "StarAngle            |" + StarAngle.
    print "DYNAMICPRESSURE      |" + Ship:DYNAMICPRESSURE.
    print "----------------PICH--------------------".
    print "TopFlapAngle         |" + TopFlapAngle.    
    print "BottomFlapAngle      |" + BottomFlapAngle.    
    print "pichSpeed            |" + pichSpeed.
    print "ForeAngleToVel       |" + ForeAngleToVel.
    print "TargetForAngle       |" + TargetForAngle.
    // print "----------------ROLL--------------------".
    // print "RollDiff             |" + RollDiff.
    // print "RollSpeed            |" + RollSpeed.
    // print "RollOffset           |" + RollOffset.    
    // print "RollReactionMultiF.  |" + RollReactionMultiFactor.
    // print "RollBreakMultiFactor |" + RollBreakMultiFactor.
    print "----------------YAW---------------------".
    print "YawDiff              |" + YawDiff.
    print "YawSpeed             |" + YawSpeed.
    print "YawOffset            |" + YawOffset.
    print "---------NAVIGATION---------------------".
    print "-----------------LAT--------------------".
    print "LAT                  |" + SHIP:GEOPOSITION:LAT.
    print "LATDiff              |" + LATDiff.
    print "LATSpeed             |" + LATSpeed.
    print "PichNavCorrection    |" + PichNavCorrection.
    print "-----------------LNG--------------------".
    print "LNG                  |" + SHIP:GEOPOSITION:LNG.
    print "LNGDiff              |" + LNGDiff.
    print "LNGSpeed             |" + LNGSpeed.
    print "RollNavCorrection    |" + RollNavCorrection.
    // print "ship:obt:LAN         |" + ship:obt:LAN.
    // print "ship:obt:LAN2        |" + ship:obt:longitudeofascendingnode.
    //print "----------------------------------------".
    print "-------------FLAPS----------------------".
    print "TLFAngle             |" + TLFAngle.
    print "TRFAngle             |" + TRFAngle.
    print "BLFAngle             |" + BLFAngle.
    print "BRFAngle             |" + BRFAngle. 
    print "----------------------------------------".
    print "StarToVelAngle       |" +     StarToVelAngle.
    print "ForeToVelAngle       |" +     ForeToVelAngle.
    print "UpToVelAngle         |" +     UpToVelAngle.
    print "----------------------------------------".
    print "periapsis            |" +     SHIP:orbit:periapsis.
    print "alt:radar            |" +     alt:radar.
    print "GroundALT            |" +     GroundALT.
    print "AltError             |" +     AltError.
    print "AltError2            |" +     AltError2.
    print "_is                  |" +     _is.
    print "mylist:length        |" +     mylist:length.
    print "_lng                 |" +     _lng.
    print "_alt                 |" +     _alt.
    print "myYAW                |" +     myYAW.
    print "AngVelToNorth        |" +     AngVelToNorth.
    print "AngPadToNorth        |" +     AngPadToNorth.
    print "_Pich................|" +     _Pich.
    print "AngPadToUp___________|" +     AngPadToUp.
    print "AngVelToUp___________|" +     AngVelToUp.
    print "frt .................|" +     frt.
    print "frt0 ................|" +     frt0.

     set _Pich to AngPadToUp - AngVelToUp.




    //wait 0.05. 
}.

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