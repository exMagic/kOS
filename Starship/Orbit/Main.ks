global isDryTest is false.
local targetAltitude is 10000.
global stableSeconds is 0.

global myYAW is 0.
global AngVelToNorth is 0.
global AngPadToNorth is 0.

global logfile is "Log" + RANDOM() + ".csv".

global _is is 0.
global c is 0.
global a1 is 0.
global d1 is 0.

set mylist to list(
    
    -151.470566324256, 69998.1408441535, 
-150.742391009578, 69673.0005468429, 
-150.016924136699, 69349.3540617903, 
-149.287089606836, 69021.1605492503, 
-148.570793614287, 68692.9447103435, 
-147.839362718919, 68356.2396444225, 
-147.107042271252, 68018.1819637975, 
-146.373768704028, 67678.2044179622, 
-145.643203257758, 67338.442430413, 
-144.908229658501, 66995.9370300412, 
-144.172471915141, 66652.5301052555, 
-143.435938059581, 66308.3076541674, 
-142.702250155715, 65965.0282248259, 
-141.964187185029, 65619.3775378627, 
-141.225368891353, 65273.1052981352, 
-140.485803397916, 64926.2754811868, 
-139.749129847852, 64580.6506985519, 
-139.008099653757, 64232.8873037805, 
-138.266350446936, 63884.7464623569, 
-137.523892121438, 63536.2835731979, 
-136.784379891132, 63189.2625530319, 
-136.040535777974, 62840.2977892973, 
-135.296010673617, 62491.1360667659, 
-134.550813507876, 62141.8124458289, 
-133.808615592945, 61794.0916227549, 
-133.062116285863, 61444.5844413843, 
-132.314982549175, 61095.0371152713, 
-131.567227150769, 60745.4769173455, 
-130.822535589173, 60397.6503792158, 
-130.073584827022, 60048.1463756866, 
-129.324056835687, 59698.6904512045, 
-128.57397293937, 59349.319187224, 
-127.827032809389, 59001.7537876992, 
-127.07590047684, 58652.5893665573, 
-126.324274768618, 58303.5284080231, 
-125.57217638755, 57954.548351321, 
-124.823322598477, 57607.3718866392, 
-124.070367284702, 57258.5942079485, 
-123.317024460695, 56909.9011773382, 
-122.563323138809, 56561.268833733, 
-121.812986648031, 56214.352614969, 
-121.058662179406, 55865.7532842928, 
-120.304075321002, 55517.1194712209, 
-119.549259257392, 55168.3946990678, 
-118.79795090101, 54821.2263537036, 
-118.042790197998, 54472.1529928707, 
-117.287514051455, 54122.7917134862, 
-116.532170298792, 53773.1031506122, 
-115.780499053742, 53424.6799675368, 
-115.025147030264, 53074.0221628923, 
-114.27357635468, 52724.579996574, 
-113.525873917794, 52376.1222516116, 
-112.782120311285, 52028.0689004757, 
-112.034949822108, 51677.1116790657, 
-111.28810767997, 51325.0641556269, 
-110.54536640626, 50973.2801168377, 
-109.803095865065, 50619.7947115373, 
-109.05767398266, 50262.8057263775, 
-108.312860635569, 49903.8669497771, 
-107.572416034608, 49544.5029640101, 
-106.829055417719, 49180.8658481018, 
-106.090213957194, 48816.3052835547, 
-105.348621003681, 48447.0026261891, 
-104.611714487581, 48076.3011921091, 
-103.872249940834, 47700.2198125764, 
-103.137648321418, 47322.176306127, 
-102.400704994694, 46938.0692801886, 
-101.668830560319, 46549.4314990578, 
-100.934864517697, 46157.8009764248, 
-100.206190734636, 45760.9514047296, 
-99.4757030584203, 45356.3820610365, 
-98.7471610556352, 44945.6971103612, 
-98.0243098295115, 44530.5091027031, 
-97.3001170757865, 44106.2059510006, 
-96.5819069237155, 43676.6101635251, 
-95.8627225409116, 43236.8568846802, 
-95.1498618682542, 42790.8908189255, 
-94.4364314818706, 42333.7033216539, 
-93.729707071286, 41869.232624091, 
-93.0228668797182, 41392.3914418668, 
-92.3231418402401, 40907.252660302, 
-91.6238323014465, 40408.3174202173, 
-90.9321457322997, 39899.9614374976, 
-90.2415097500471, 39376.5789543396, 
-89.5591125584903, 38842.6861213164, 
-88.8785582875036, 38292.223878156, 
-88.2069910963822, 37730.1627947812, 
-87.5382072284129, 37150.3843700915, 
-86.8794021969829, 36555.1427262194, 
-86.2246567963196, 35947.1083691431, 
-85.5779644054779, 35320.0074127514, 
-84.9432569123262, 34679.5972218059, 
-84.315087259589, 34019.201500676, 
-83.7005713997486, 33345.4979405702, 
-83.0945462206918, 32651.8651866732, 
-82.5041613504092, 31945.7530634336, 
-81.9247333443451, 31220.9413134567, 
-81.3631943122194, 30484.7011348142, 
-80.8152649836572, 29730.2015749397, 
-80.2877939264316, 28965.4675779999, 
-79.7770443100973, 28185.4374685304, 
-79.2896025429484, 27399.86207958, 
-78.8220076845461, 26602.9337351207, 
-78.3781392811019, 25800.1994368642, 
-77.961292471465, 24997.5688615002, 
-77.5702815492291, 24193.9577583994, 
-77.2008736563818, 23381.0133061764, 
-76.8603149286817, 22560.9938736289, 
-76.5484336748034, 21714.1609624277, 
-76.2719917813451, 20861.4234122215, 
-76.0200598484762, 19980.4682090766, 
-75.7929188772659, 19081.4642200834, 
-75.5908137698965, 18174.8684794048, 
-75.4106346404439, 17251.6193448443, 
-75.2603211060415, 16379.2750113665, 
-75.1363889695229, 15546.8754541422, 
-75.0371915790184, 14766.9728738606, 
-74.9576241069378, 14019.5018009911, 
-74.8897648566017, 13258.3595429619, 
-74.8318862678555, 12489.5977041172, 
-74.7825046628827, 11718.041421547, 
-74.7412451095774, 10964.5146615853, 
-74.7068258124481, 10233.6371568593, 
-74.6785186513213, 9538.47312757024, 
-74.655459186683, 8888.04298274231, 
-74.6365066910324, 8277.14545449393, 
-74.6210064459465, 7708.12031206139, 
-74.6080328266929, 7171.50418412965, 
-74.5971875538261, 6667.2174149364, 
-74.5879323119662, 6185.52926591539, 
-74.5799162909928, 5726.2336477479, 
-74.5728246375723, 5288.93155392457, 
-74.5665195989986, 4865.90502162953, 
-74.5608589474073, 4459.63031225442, 
-74.5554480531885, 4066.00194379431, 
-74.5505193772912, 3687.15749102237, 
-74.5459139038067, 3319.25120376342, 
-74.5414297111926, 2964.53778821556, 
-74.537196157148, 2622.89247981436, 
-74.5332001220377, 2289.50907733617, 
-74.5291690102854, 1968.28223053669, 
-74.5253692154598, 1653.99692714494, 
-74.5215840516887, 1345.24114867218, 
-74.517455896251, 1035.53655640152, 
-74.5147850342053, 750.372443811619, 
-74.5149928616973, 584.047472906415, 
-74.5150795221929, 466.009462135611, 
-74.5151830279328, 358.485517052235, 
-74.5152618357031, 254.780938213225, 
-74.5153979447012, 151.733891020995, 
-74.5155181955706, 83.5275375399506
    
    ).

global mylex is lexicon().
set mylex to lexicon(mylist).

global _lng is 0.
global _alt is 0.

global AltError is 0.
global AltError2 is 0.

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
// global RightOffset is 0.
// global LeftOffset is 0.
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
global TargetForAngle is 66.

global GroundALT is 0.

global StageNo is 0.
global lastCount is 0.
global lastCount2 is 0.
global th is 0.

SET vess to SHIP.
global partlist is vess:PARTSNAMED("hinge.04").

until isDryTest = false{ // Set to TRUE if you want to run dry test on the ground.
    RCS ON.
    GetTelemetry().
    DrawVec().
    SetFlapsVac().  
    printComp(). 
}

/////////////////////////////////////////////////////////////////////////////
////////////////////////////////// STAGES ///////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

//stage.
partlist[BRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//bootom right
partlist[BLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//bottom left
partlist[TRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//top right
partlist[TLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//top left
until StageNo=1{
    // orbit
    GetTelemetry().
    printComp().    
    if (SHIP:GEOPOSITION:LNG<145 and SHIP:GEOPOSITION:LNG>140){
        set StageNo to StageNo + 1.
    }    
}

until StageNo=2{ 
    // deorbit burn
    
    local targetPer is 37700.
    GetTelemetry().
    printComp().  
    RCS ON.    
      
    if (SHIP:GEOPOSITION:LNG>140){
        LOCK STEERING TO retrograde.
    } 
    if (SHIP:GEOPOSITION:LNG>144){
        LOCK STEERING TO retrograde.
        if (SHIP:orbit:periapsis>47600){
            lock throttle to 0.2.
            
        }else{
            lock throttle to 0.
        }
    } 
    if (SHIP:GEOPOSITION:LNG>149){        
        if (SHIP:orbit:periapsis>targetPer){
            local _th is (SHIP:orbit:periapsis/10000)-(targetPer/10000).
            lock throttle to _th.
            
        }else{
            lock throttle to 0.
            RCS off.
            set StageNo to StageNo + 1.
        }
    }     
}

until StageNo=3{
    // Descent    
    DrawVec().
    printComp().    
    GetTelemetry().
    UNLOCK STEERING.
    if ship:altitude<70000{
        // set StageNo to StageNo + 1.

        //local xx is (VANG(SHIP:VELOCITY:orbit, SHIP:up:vector)-70) * -1.
        local xx is (VANG(SHIP:VELOCITY:SURFACE, SHIP:up:vector)-TargetForAngle) * -1.
        
        if ship:altitude>53000{
            RCS ON.         
            LOCK STEERING TO Up + R(0,xx,VANG(SHIP:VELOCITY:surface, SHIP:north:vector)-180).
        }else{
            RCS off. 

            UNLOCK STEERING.
        }
        SetFlapsVac().
        

        // if ship:altitude >23000{
        //     SetFlapsVac().
        // }else{
        //     SetFlaps().
        // }
        
        if ship:altitude <1200{
            set StageNo to StageNo + 1.
        }
    }
}



until StageNo=4{
    // Fip to up
    DrawVec().
    printComp().    
    GetTelemetry().
    LOCK STEERING TO Up + R(0,0,180).

    partlist[BRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//bootom right
    partlist[BLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//bottom left

    partlist[TRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//top right
    partlist[TLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MaxFlapAngle).//top left

    if ForeAngle<60{
        set StageNo to StageNo + 1.
    }
}

until StageNo=5{
    // Land
    DrawVec().
    printComp().    
    GetTelemetry().
    LOCK STEERING TO SRFRETROGRADE.
    partlist[TRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//top right
    partlist[TLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle).//top left
    set th to 1 / (  50 /  -ship:VERTICALSPEED).
    if ship:altitude < 200{
        GEAR ON.
    partlist[BRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle+20).//bootom right
    partlist[BLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", MinFlapAngle+20).//bottom left
    }
    if ship:altitude < 105{
        set th to th + (-ship:VERTICALSPEED/5).
        LOCK STEERING TO Up + R(0,0,180).
    }
    LOCK throttle to th.
}



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
//  function GetError{
    
//     set _lng to mylex[_is].
//     set _lng to mylex[_is].
//     set _alt to mylex[_is+1].
    
//     if(SHIP:GEOPOSITION:LNG>_lng){
//         set _is to _is+1.
//         set AltError to _alt - SHIP:ALTITUDE.
//     }
// }
 function SetAltError{
    if (_is<mylist:length){
        set _lng to mylist[_is].
        set _alt to mylist[_is+1].        
        if(SHIP:GEOPOSITION:LNG>_lng){
            set _is to _is+2.
            set AltError to  SHIP:ALTITUDE - _alt.
        }
    }
}

 function derr{
    // set c to sqrt((LNGDiff*LNGDiff)+(LATDiff*LATDiff)).
    // set a1 to 45 * (abs(LATDiff)/abs(LNGDiff))-d1.
    
    set AngVelToNorth to VANG(SHIP:VELOCITY:surface,ship:north:vector).

    if (LATDiff<0){
        set AngPadToNorth to 90 + (45 * (abs(LATDiff)/abs(LNGDiff))).
    }else{
        set AngPadToNorth to 90 - (45 * (abs(LATDiff)/abs(LNGDiff))).
    }

    

}



function GetTelemetry{

    if (ship:altitude<70000){
        if (time:seconds-lastCount2>4){
            set lastCount2 to  time:seconds.
            LOG SHIP:GEOPOSITION:LNG + ", " + ship:altitude + ", " to logfile.
        }
        SetAltError().
        derr().
    }




   




    // if ship:altitude<10000{
    //     set GroundALT to ship:altitude-SHIP:GEOPOSITION:TERRAINHEIGHT.
    // }
    set GroundALT to ship:altitude-SHIP:GEOPOSITION:TERRAINHEIGHT.

    set LATDiff to padLAT - SHIP:GEOPOSITION:LAT.
    set LNGDiff to PadLNG - 0.001 - SHIP:GEOPOSITION:LNG.
    set TargetVector to SHIP:UP:vector + R(0,(VANG(SHIP:VELOCITY:surface, SHIP:up:vector)-70) * -1,0).

    if (time:seconds-lastCount>0.1){
        set lastCount to  time:seconds.

        // LATSpeed
        set newLat to SHIP:GEOPOSITION:LAT.
        set LATSpeed to (previousLat - newLat).
        set previousLat to newLat.  
        
        // LNGSpeed
        set newLng to SHIP:GEOPOSITION:LNG.
        set LNGSpeed to (previousLng - newLng).
        set previousLng to newLng.  

        // PICH SPEED
        set newPitch to ForeAngle.
        set pichSpeed to (previousPitch - newPitch) * -1.
        set previousPitch to newPitch.  
        // ROLL SPEED
        set newRoll to StarAngle.
        set RollSpeed to (previousRoll - newRoll) * -1.
        set previousRoll to newRoll.  
        // YAW SPEED        
        set newYaw to YawDiff.
        set YawSpeed to (previousYaw - newYaw) * -1.
        set previousYaw to newYaw.                             
    }

    set ForeAngle to GetForeAngleToUP().
    set StarAngle to GetStarAngleToUP().
    set TopAngle to GetTopAngleToUP().

    set StarToVelAngle to VANG(SHIP:VELOCITY:surface, SHIP:facing:starvector).
    set ForeToVelAngle to VANG(SHIP:VELOCITY:surface, SHIP:facing:forevector).
    set UpToVelAngle to VANG(SHIP:VELOCITY:orbit, SHIP:facing:upvector).
    
    set StarNorthAngle to GetStarAngleToNORTH().
    set ForeAngleToVel to GetForeAngleToVel().
}
function SetFlapsVac{

    /////////////////////////////////////////////////////
    // -- PICH
    local PitchReactionMultiFactor is 0.5.
    local PitchBreakMultiFactor is 4.
    
    set AltError2 to AltError/15.
    if (AltError2>20){
        set AltError2 to 20.
    }
    if (AltError2<-20){
        set AltError2 to -20.
    }

    set TopFlapAngle to TopFlapAngleDefoult - (ForeToVelAngle-(TargetForAngle + AltError2))* PitchReactionMultiFactor.
    set BottomFlapAngle to BottomFlapAngleDefoult + (ForeToVelAngle-(TargetForAngle + AltError2))* PitchReactionMultiFactor.
    
    if (TopFlapAngle>MaxFlapAngle){
        set TopFlapAngle to MaxFlapAngle.
    }
    if (TopFlapAngle<MinFlapAngle){
        set TopFlapAngle to MinFlapAngle.
    }
    if (BottomFlapAngle>MaxFlapAngle){
        set BottomFlapAngle to MaxFlapAngle.
    }
    if (BottomFlapAngle<MinFlapAngle){
        set BottomFlapAngle to MinFlapAngle.
    }
    // // -- PichNavCorrection
    // local max is 11.
    // local LATOffset is 0.00462. // Requaire offset of LAT for flipp from horizontal to vertical
    // set PichNavCorrection to (LATDiff + LATOffset) * 3000.
    //     if (PichNavCorrection>max){
    //         set PichNavCorrection to max.
    //     }
    //     if (PichNavCorrection <-max){
    //         set PichNavCorrection to -max.
    // }
    
    /////////////////////////////////////////////////////
    // -- ROLL
    set RollReactionMultiFactor to 0.2.
    set RollBreakMultiFactor to 0.1.   

    set RollDiff to StarToVelAngle -90.
    
    // RollNavCorrection
    // set RollNavCorrection to LNGDiff * 5000 + (LNGSpeed/10).
    // if (RollNavCorrection >11){
    //     set RollNavCorrection to 11.
    // }
    //set RollDiff to RollDiff + RollNavCorrection.
    // if (ship:GROUNDSPEED<300){
    //     set RollOffset to RollDiff * RollReactionMultiFactor + RollSpeed * RollBreakMultiFactor.
    //     // if (RollDiff>0){//lean to left
    //     //     set RightOffset to RollDiff * -1 * RollReactionMultiFactor + RollSpeed * RollBreakMultiFactor.
    //     //     set LeftOffset to RollDiff * RollReactionMultiFactor - RollSpeed * RollBreakMultiFactor.
    //     // }else{//lean to right
    //     //     set LeftOffset to RollDiff * RollReactionMultiFactor - RollSpeed * RollBreakMultiFactor.
    //     //     set RightOffset to RollDiff * -1 * RollReactionMultiFactor + RollSpeed * RollBreakMultiFactor.
    //     // }
    // }else{
    //     set RollOffset to 0.
    // }
    set RollOffset to 0.
    

    /////////////////////////////////////////////////////
    // -- YAW
    local YawReactionMultiFactor is 2.
    local YawBreakMultiFactor is 4.


    if (SHIP:altitude>15000){
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
    if (SHIP:altitude>15000){
     //   set Va to VCRS(SHIP:VELOCITY:surface, SHIP:up:vector).
        set YawDiff to YawDiff - (AngPadToNorth-90).
        set myYAW to MIN((AngPadToNorth-AngVelToNorth)*80, 40).
    }else{
        set myYAW to 0.
    }
   

    set YawOffset to YawDiff * YawReactionMultiFactor + YawSpeed * YawBreakMultiFactor - myYAW.// + (d1-a1)/2.// + (LATDiff*10).

    if (YawOffset>30){
        set YawOffset to 30.
    }
    if (YawOffset<-30){
        set YawOffset to -30.
    }



    ///////////////////////////////////////////////////
    ///////////////////////////////////////// SET FLAPS
    ///////////////////////////////////////////////////


    set TLFAngle to TopFlapAngle + PichNavCorrection + RollOffset/2 + pichSpeed * PitchBreakMultiFactor + YawOffset.
    set TRFAngle to TopFlapAngle + PichNavCorrection - RollOffset/2 + pichSpeed * PitchBreakMultiFactor - YawOffset.

    set BLFAngle to BottomFlapAngle + RollOffset - pichSpeed * PitchBreakMultiFactor - YawOffset/5.
    set BRFAngle to BottomFlapAngle - RollOffset - pichSpeed * PitchBreakMultiFactor + YawOffset/5.

    //Limit flaps angle
    if (TLFAngle>MaxFlapAngle){
        set TLFAngle to MaxFlapAngle.
    }else if (TLFAngle<MinFlapAngle){
        set TLFAngle to MinFlapAngle.
    }
    if (TRFAngle>MaxFlapAngle){
        set TRFAngle to MaxFlapAngle.
    }else if (TRFAngle<MinFlapAngle){
        set TRFAngle to MinFlapAngle.
    }
    if (BLFAngle>MaxFlapAngle){
        set BLFAngle to MaxFlapAngle.
    }else if (BLFAngle<MinFlapAngle){
        set BLFAngle to MinFlapAngle.
    }
    if (BRFAngle>MaxFlapAngle){
        set BRFAngle to MaxFlapAngle.
    }else if (BRFAngle<MinFlapAngle){
        set BRFAngle to MinFlapAngle.
    }

    partlist[TRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", TRFAngle).//top right
    partlist[TLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", TLFAngle).//top left

    partlist[BRFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", BRFAngle).//bootom right
    partlist[BLFIndex]:GETMODULE("ModuleRoboticServoHinge"):SETFIELD("Target Angle", BLFAngle).//bottom left

    // //Adjust TargetForAngle to keep velocity vector close to vertical as posible.
    // if(isDryTest = false){
    //     if (ForeAngleToVel < 90){
    //         set TargetForAngle to TargetForAngle-0.5.
    //     }else{
    //         set TargetForAngle to TargetForAngle+0.5.
    //     } 
    // }
    if (ship:GROUNDSPEED<1000){
        if (ForeAngleToVel > 80){
            set TargetForAngle to TargetForAngle-0.2.
        }else{
            set TargetForAngle to TargetForAngle+0.2.
        } 
    }

    if (ship:GROUNDSPEED<800 and TopFlapAngleDefoult>125){       
            set TopFlapAngleDefoult to TopFlapAngleDefoult - 0.2.
            set BottomFlapAngleDefoult to BottomFlapAngleDefoult - 0.2.
    }
    
}.


function printComp{
    clearscreen.
    print "isDryTest            |" + isDryTest.
    print "StageNo:             |" + StageNo.
    print "ship:VERTICALSPEED   |" + ship:VERTICALSPEED.
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
    print "ship:obt:LAN         |" + ship:obt:LAN.
    print "ship:obt:LAN2        |" + ship:obt:longitudeofascendingnode.
    print "----------------------------------------".
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




    //wait 0.05. 
}.

function DrawVec{

    // SET cros TO VECDRAW(
    //   V(0,0,0),
    //   VCRS(SHIP:VELOCITY:surface, SHIP:up:vector),
    //   RGB(1,0.5,0.2),
    //   "anArrow44",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).

    // SET anArrow44 TO VECDRAW(
    //   V(0,0,0),
    //   VCRS(SHIP:VELOCITY:surface, SHIP:up:vector),
    //   //SHIP:UP:vector + R(0,(VANG(SHIP:VELOCITY:orbit, SHIP:up:vector)-70) * -1,0),
    //   RGB(0,0.7,1),
    //   "anArrow44",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).
    //     SET anArrow44 TO VECDRAW(
    //   V(0,0,0),
    //   Vb,
    //   //SHIP:UP:vector + R(0,(VANG(SHIP:VELOCITY:orbit, SHIP:up:vector)-70) * -1,0),
    //   RGB(1,0.7,0),
    //   "anArrow44",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).

    // SET anArrow TO VECDRAW(
    //   V(0,0,0),
    //   SHIP:FACING:vector,
    //   RGB(1,0,0),
    //   "",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).

    SET anArrow2 TO VECDRAW(
      V(0,0,0),
      SHIP:UP:vector,
      RGB(0,1,0),
      "UP",
      20.0,
      TRUE,
      0.005,
      TRUE,
      TRUE
    ).

    SET anArrow3 TO VECDRAW(
      V(0,0,0),
      SHIP:VELOCITY:SURFACE,
      RGB(0,0,1),
      "",
      1.0,
      TRUE,
      0.5,
      TRUE,
      TRUE
    ).
    // SET anArrow6 TO VECDRAW(
    //   V(0,0,0),
    //   SHIP:VELOCITY:orbit,
    //   RGB(1,0,1),
    //   "",
    //   1.0,
    //   TRUE,
    //   0.5,
    //   TRUE,
    //   TRUE
    // ).

    // SET anArrow4 TO VECDRAW(
    //   V(0,0,0),
    //   SHIP:FACING:UPVECTOR,
    //   RGB(1,0.5,0.5),
    //   "",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).
    
    // SET anArrow5 TO VECDRAW(
    //   V(0,0,0),
    //   SHIP:FACING:STARVECTOR,
    //   RGB(0,1,1),
    //   "",
    //   20.0,
    //   TRUE,
    //   0.005,
    //   TRUE,
    //   TRUE
    // ).
    // //Create a vector to center of kerbin
    // set geo to kerbin:position.
    // set geo:mag to (ship:altitude/2).
    // //Draw global axes for frame of reference
    // //                      /startPos/ /vector/  //color//        /label/  /size/
    // set xAxis to VECDRAWARGS( geo, V(200000,0,0), RGB(1.0,0.5,0.5), "X axis", 5, TRUE ).
    // set yAxis to VECDRAWARGS( geo, V(0,200000,0), RGB(0.5,1.0,0.5), "Y axis", 5, TRUE ).
    // set zAxis to VECDRAWARGS( geo, V(0,0,200000), RGB(0.5,0.5,1.0), "Z axis", 5, TRUE ).
}.
