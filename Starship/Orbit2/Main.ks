wait 2.
RUNONCEPATH("0:/boot/kOS/Starship/Orbit2/trajectory.ks").
RUNONCEPATH("0:/boot/kOS/Starship/Orbit2/functions.ks").
RUNONCEPATH("0:/boot/kOS/Starship/Orbit2/steps.ks").

global yml is 0.
global myYAW is 0.
global AngVelToNorth is 0.
global AngPadToNorth is 0.

global _Pich is 0.
global AngVelToUp is 0.
global AngPadToUp is 0.
global frt is 0.
global frt0 is 0.

global logfile is "Log" + RANDOM() + ".csv".

global _is is 0.
global c is 0.
global a1 is 0.
global d1 is 0.


global _lng is 0.
global _alt is 0.
global _lng2 is 0.
global _alt2 is 0.

global TRError is 0.
global TRErrorSpeed is 0.
global TRError2 is 0.

global TLFIndex    is 1.
global TRFIndex    is 0.
global BLFIndex    is 2.
global BRFIndex    is 3.

global ForeAngle is 0.
global StarAngle is 0.
global TopAngle is 0.

global Va is V(0,0,0).
global Vb is V(0,0,0).

global StarToVelAngle is 0.
global ForeToVelAngle is 0.
global UPToVelAngle is 0.

global StarNorthAngle is 0.
global ForeAngleToVel is 0.

global pichSpeed is 0.

global RollDiff is 0.
global RollSpeed is 0.
global RollOffset is 0.

global RollBreakMultiFactor is 0.
global RollReactionMultiFactor is 0.
global YawDiff is 0.
global YawSpeed is 0.
global YawOffset is 0.

global padLAT is -0.09721.
global PadLNG is -74.55766.
global LATSpeed is 0.
global LATDiff is 0.
global PichNavCorrection is 0.

global LNGSpeed is 0.
global LNGDiff is 0.
global RollNavCorrection is 0.

global previousPitch is 0.
global previousRoll is 0.
global previousYaw is 0.
global previousLat is 0.
global previousLng is 0.
global previousTRError is 0.


global TLFAngle is 0.
global TRFAngle is 0.
global BLFAngle is 0.
global BRFAngle is 0.


global TopFlapAngle is 0. 
global BottomFlapAngle is 0.

global MaxFlapAngle is 180.
global MinFlapAngle is 90.
global TopFlapAngleDefoult is 130.
global BottomFlapAngleDefoult is 130.
global TargetForAngle is 63.

global GroundALT is 0.

global StageNo is 0.
global lastCount is 0.
global lastCount2 is 0.
global th is 0.


global partlist is SHIP:PARTSNAMED("hinge.04").

SET Xs to 1.
UNTIL mylist[Xs] <30000 {
    set Xs to Xs +2.
}

//stage.

partlist[BRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//bootom right
partlist[BLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//bottom left
partlist[TRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//top right
partlist[TLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//top left

SET step TO "Descent".
// runstep("Orbit",step_Orbit@).
// runstep("Deorbit_burn",step_Deorbit_burn@).
runstep("Descent",step_Descent@).
runstep("Flip_to_up",step_Flip_to_up@).
runstep("Land",step_Land@).




/////////////////////////////////////////////////////////////////////////////
/////////////////////////////// MY FUNCTIONS ////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

function GetTopAngleToUP{
    return VANG(ship:facing:TOPVECTOR,ship:up:vector).
}
function GetStarAngleToUP{
    return VANG(ship:facing:STARVECTOR,ship:up:vector).
}
function GetForeAngleToUP{  
    return VANG(ship:facing:forevector,ship:up:vector).
}
function GetStarAngleToNORTH{  
    return VANG(ship:facing:STARVECTOR,ship:north:vector).
}
function GetForeAngleToVel{  
    return VANG(ship:facing:forevector,SHIP:VELOCITY:SURFACE).
}

 

function SetFlapsVac{

    /////////////////////////////////////////////////////
    // -- PICH
    local PitchReactionMultiFactor is 0.5.
    local PitchBreakMultiFactor is 4.
    
    local limit is 30.
    set fr to 15.
    if (SHIP:altitude<15000){
        set fr to 5.
        set limit to 20.
    }
    set TRError2 to MAX(MIN(TRError/fr,limit),-limit).        
    //set TRError2 to 0.      

    set TopFlapAngle to TopFlapAngleDefoult - (ForeToVelAngle-(TargetForAngle + TRError2))* PitchReactionMultiFactor.
    set BottomFlapAngle to BottomFlapAngleDefoult + (ForeToVelAngle-(TargetForAngle + TRError2))* PitchReactionMultiFactor.    

    set TopFlapAngle to MAX(MIN(TopFlapAngle,MaxFlapAngle),MinFlapAngle).        
    set BottomFlapAngle to MAX(MIN(BottomFlapAngle,MaxFlapAngle),MinFlapAngle).     
    
    /////////////////////////////////////////////////////
    // -- ROLL
    set RollReactionMultiFactor to 0.2.
    set RollBreakMultiFactor to 0.1.   

    set RollDiff to StarToVelAngle -90.   
    set RollOffset to 0.    

    /////////////////////////////////////////////////////
    // -- YAW
    local YawReactionMultiFactor is 0.9.
    local YawBreakMultiFactor is 8.

    if (SHIP:altitude>10000){
        set Va to VCRS(SHIP:VELOCITY:surface, SHIP:up:vector).
    }else{
        set Va to ship:north:vector.
    }    
    
    set Vb to VCRS(SHIP:up:vector,Va).

    if (VANG(ship:facing:starvector,Va)>90){
        set YawDiff to VANG(ship:facing:forevector,Va)-90.            
    }else{
        if (VANG(ship:facing:forevector,Va)<90){
            set YawDiff to (90 + VANG(ship:facing:forevector,Va)) *-1.            
        }else{
            set YawDiff to 180 - (VANG(ship:facing:forevector,Va)-90).            
        }
    }
    set myYAWLimit to SHIP:altitude - (SHIP:altitude/1.001) - 10.
    set myYAWLimit to MAX(MIN(myYAWLimit,30),4).

    set myYAWMultifactor to SHIP:altitude - (SHIP:altitude/1.002) - 20.
    set myYAWMultifactor to MAX(MIN(myYAWMultifactor,100),0.5).


    set myYAW to MAX(MIN((AngPadToNorth-AngVelToNorth)*myYAWMultifactor, myYAWLimit),-myYAWLimit).
    // if (SHIP:altitude>53000){
    //     set myYAW to 0.
    // }
    //set myYAW to 0.   
    set yError to YawDiff * YawReactionMultiFactor.
    set ySpeed to YawSpeed * YawBreakMultiFactor.
    
    // if (SHIP:altitude<20000){
    //     set yml to SHIP:altitude - (SHIP:altitude/1.0001) + 0.3.
    //     set yml to MAX(MIN(yml,3),0.4).
    // }else{
    //     set yml to 3.
    // }

    set yml to SHIP:altitude - (SHIP:altitude/1.0001) -0.5.
    set yml to MAX(MIN(yml,3),0.4).

    set YawOffset to (yError + ySpeed - myYAW)*yml.
    
    // set ys to abs(ySpeed).
    // if(ys>0){
    //     set YawOffset to yError / (ys*2) - myYAW.
    // }else{
    //     set YawOffset to yError - myYAW.
    // }

    set YawOffset to MAX(MIN(YawOffset,30),-30).     

    ///////////////////////////////////////////////////
    ///////////////////////////////////////// SET FLAPS
    ///////////////////////////////////////////////////


    set TLFAngle to TopFlapAngle + PichNavCorrection + RollOffset/2 + pichSpeed * PitchBreakMultiFactor + YawOffset.
    set TRFAngle to TopFlapAngle + PichNavCorrection - RollOffset/2 + pichSpeed * PitchBreakMultiFactor - YawOffset.

    set BLFAngle to BottomFlapAngle + RollOffset - pichSpeed * PitchBreakMultiFactor - YawOffset/4.
    set BRFAngle to BottomFlapAngle - RollOffset - pichSpeed * PitchBreakMultiFactor + YawOffset/4.


    set TLFAngle to MAX(MIN(TLFAngle,MaxFlapAngle),MinFlapAngle).        
    set TRFAngle to MAX(MIN(TRFAngle,MaxFlapAngle),MinFlapAngle).        
    set BLFAngle to MAX(MIN(BLFAngle,MaxFlapAngle),MinFlapAngle).        
    set BRFAngle to MAX(MIN(BRFAngle,MaxFlapAngle),MinFlapAngle). 

    partlist[TRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", TRFAngle).//top right
    partlist[TLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", TLFAngle).//top left

    partlist[BRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", BRFAngle).//bootom right
    partlist[BLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", BLFAngle).//bottom left
    
}.





