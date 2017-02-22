within ;
package LBNL71T_MPC

  model RunMPC

    parameter Modelica.SIunits.Angle lon= -87.6298*Modelica.Constants.pi/180;
    parameter Modelica.SIunits.Angle lat= 41.8781*Modelica.Constants.pi/180;
    parameter Modelica.SIunits.Time timZon= -6*3600;
    parameter Modelica.SIunits.Time modTimOffset = 0;

    Buildings.BoundaryConditions.WeatherData.ReaderTMY3 epw(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data"
    annotation (Placement(transformation(extent={{-540,20},{-430,120}})));
  MPC mpc(
    timZon=timZon,
    modTimOffset=0,
    lon=lon,
    lat=lat)
    annotation (Placement(transformation(extent={{-108,-102},{146,138}})));
    Modelica.Blocks.Sources.CombiTimeTable intGaiFra(
         extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,
        0.05; 3600*8,0.05; 3600*8,0.9; 3600*12,0.9; 3600*12,0.8; 3600*13,
        0.8; 3600*13,1; 3600*17,1; 3600*17,0.1; 3600*20,0.1; 3600*20,0.05;
        3600*24,0.05])
    "Fraction of internal heat gain"
      annotation (Placement(transformation(extent={{-320,200},{-300,220}})));
    Modelica.Blocks.Math.MatrixGain gai(K=20*[0.4; 0.4; 0.2])
    "Matrix gain to split up heat gain in radiant, convective and latent gain"
      annotation (Placement(transformation(extent={{-280,200},{-260,220}})));
  Modelica.Blocks.Routing.DeMultiplex3 deMultiplex3_1
    annotation (Placement(transformation(extent={{222,118},{202,138}})));
    Modelica.Blocks.Sources.CombiTimeTable intGaiFra1(
         extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,
        0.05; 3600*7,0.05; 3600*7,0.1; 3600*19,0.1; 3600*19,0.05; 3600*24,
        0.05]) "Fraction of internal heat gain"
      annotation (Placement(transformation(extent={{-320,160},{-300,180}})));
    Modelica.Blocks.Math.MatrixGain gai1(
                                        K=20*[0.4; 0.4; 0.2])
    "Matrix gain to split up heat gain in radiant, convective and latent gain"
      annotation (Placement(transformation(extent={{-280,160},{-260,180}})));
  Modelica.Blocks.Routing.DeMultiplex3 deMultiplex3_2
    annotation (Placement(transformation(extent={{220,48},{200,68}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-412,60},{-392,80}})));
  RapidMPC.BoundaryConditions.WeatherProcessor weatherProcessor(
      modTimOffset=0,
      lon=-1.5344934783534,
      lat=0.73268921998722,
      timZon=-21600)
      annotation (Placement(transformation(extent={{-316,36},{-248,104}})));
  RapidMPC.Examples.Controllers.DualSetpoint DualSetpoint(
      OnStatus=true,
      Setpoint=20 + 273,
      Setback=5)
      annotation (Placement(transformation(extent={{-82,-172},{-62,-152}})));
  equation

  connect(deMultiplex3_1.y1[1], mpc.intRad_wes) annotation (Line(points={{201,135},
            {176.5,135},{176.5,111.333},{156.583,111.333}},        color={0,
          0,127}));
  connect(deMultiplex3_1.y2[1], mpc.intCon_wes) annotation (Line(points={{201,128},
            {176,128},{176,98},{156.583,98}},        color={0,0,127}));
  connect(deMultiplex3_1.y3[1], mpc.intLat_wes) annotation (Line(points={{201,121},
            {174.5,121},{174.5,84.6667},{156.583,84.6667}},        color={0,
          0,127}));
  connect(deMultiplex3_1.y1[1], mpc.intRad_eas) annotation (Line(points={{201,135},
            {184,135},{184,22.4444},{156.583,22.4444}},        color={0,0,
          127}));
  connect(deMultiplex3_1.y2[1], mpc.intCon_eas) annotation (Line(points={{201,128},
            {188,128},{188,9.11111},{156.583,9.11111}},        color={0,0,
          127}));
  connect(deMultiplex3_1.y3[1], mpc.intLat_eas) annotation (Line(points={{201,121},
            {194,121},{194,-4.22222},{156.583,-4.22222}},        color={0,0,
          127}));
  connect(deMultiplex3_2.y1[1], mpc.intRad_hal) annotation (Line(points={{199,65},
            {178,65},{178,66.8889},{156.583,66.8889}},       color={0,0,127}));
  connect(deMultiplex3_2.y2[1], mpc.intCon_hal) annotation (Line(points={{199,58},
            {170,58},{170,53.5556},{156.583,53.5556}},       color={0,0,127}));
  connect(deMultiplex3_2.y3[1], mpc.intLat_hal) annotation (Line(points={{199,51},
            {170,51},{170,40.2222},{156.583,40.2222}},       color={0,0,127}));
  connect(epw.weaBus, weaBus) annotation (Line(
      points={{-430,70},{-402,70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.pAtm, weatherProcessor.pAtm) annotation (Line(
      points={{-402,70},{-396,70},{-388,70},{-388,102},{-318,102}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDewPoi, weatherProcessor.TDewPoi) annotation (Line(
      points={{-402,70},{-388,70},{-388,96},{-318,96}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.TDryBul, weatherProcessor.TDryBul) annotation (Line(
      points={{-402,70},{-388,70},{-388,89.8},{-318,89.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.relHum, weatherProcessor.relHum) annotation (Line(
      points={{-402,70},{-388,70},{-388,83.8},{-318,83.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.nOpa, weatherProcessor.nOpa) annotation (Line(
      points={{-402,70},{-388,70},{-388,77.8},{-318,77.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.celHei, weatherProcessor.celHei) annotation (Line(
      points={{-402,70},{-396,70},{-386,70},{-386,71.8},{-318,71.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.nTot, weatherProcessor.nTot) annotation (Line(
      points={{-402,70},{-388,70},{-388,66},{-318,66}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.winSpe, weatherProcessor.winSpe) annotation (Line(
      points={{-402,70},{-396,70},{-388,70},{-388,60},{-318,60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.winDir, weatherProcessor.winDir) annotation (Line(
      points={{-402,70},{-388,70},{-388,53.6},{-318,53.6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HHorIR, weatherProcessor.HorIR) annotation (Line(
      points={{-402,70},{-388,70},{-388,47.8},{-318,47.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDirNor, weatherProcessor.HDirNor) annotation (Line(
      points={{-402,70},{-396,70},{-388,70},{-388,41.8},{-318,41.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HGloHor, weatherProcessor.HGloHor) annotation (Line(
      points={{-402,70},{-388,70},{-388,36},{-318,36}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(mpc.weaPAtm, weatherProcessor.pAtm) annotation (Line(points={{
            -118.583,129.111},{-380,129.111},{-380,102},{-318,102}},
                                                                   color={0,
          0,127}));
  connect(mpc.weaTDewPoi, weatherProcessor.TDewPoi) annotation (Line(points={{
            -118.583,115.778},{-136,115.778},{-136,146},{-378,146},{-378,96},{
            -318,96}},color={0,0,127}));
  connect(mpc.weaTDryBul, weatherProcessor.TDryBul) annotation (Line(points={{
            -118.583,102.444},{-138,102.444},{-138,144},{-376,144},{-376,89.8},
            {-318,89.8}},     color={0,0,127}));
  connect(mpc.weaRelHum, weatherProcessor.relHum) annotation (Line(points={{
            -118.583,89.1111},{-140,89.1111},{-140,142},{-374,142},{-374,83.8},
            {-318,83.8}},     color={0,0,127}));
  connect(mpc.weaNOpa, weatherProcessor.nOpa) annotation (Line(points={{
            -118.583,75.7778},{-142,75.7778},{-142,140},{-372,140},{-372,77.8},
            {-318,77.8}},
                        color={0,0,127}));
  connect(mpc.weaCelHei, weatherProcessor.celHei) annotation (Line(points={{
            -118.583,62.4444},{-144,62.4444},{-144,138},{-370,138},{-370,71.8},
            {-318,71.8}},     color={0,0,127}));
  connect(mpc.weaNTot, weatherProcessor.nTot) annotation (Line(points={{
            -118.583,49.1111},{-146,49.1111},{-146,136},{-368,136},{-368,66},{
            -318,66}},color={0,0,127}));
  connect(mpc.weaWinSpe, weatherProcessor.winSpe) annotation (Line(points={{
            -118.583,35.7778},{-134,35.7778},{-134,34},{-148,34},{-148,134},{
            -366,134},{-366,60},{-318,60}},color={0,0,127}));
  connect(mpc.weaWinDir, weatherProcessor.winDir) annotation (Line(points={{
            -118.583,22.4444},{-150,22.4444},{-150,132},{-364,132},{-364,53.6},
            {-318,53.6}},     color={0,0,127}));
  connect(mpc.weaHHorIR, weatherProcessor.HorIR) annotation (Line(points={{
            -118.583,9.11111},{-152,9.11111},{-152,130},{-362,130},{-362,47.8},
            {-318,47.8}},
                        color={0,0,127}));
  connect(mpc.weaHDirNor, weatherProcessor.HDirNor) annotation (Line(points={{
            -118.583,-4.22222},{-154,-4.22222},{-154,128},{-360,128},{-360,41.8},
            {-318,41.8}},     color={0,0,127}));
  connect(mpc.weaHGloHor, weatherProcessor.HGloHor) annotation (Line(points={{
            -118.583,-17.5556},{-156,-17.5556},{-156,126},{-358,126},{-358,36},
            {-318,36}},   color={0,0,127}));
  connect(weatherProcessor.HDifHor, mpc.weaHDifHor) annotation (Line(points={{-247,
            102},{-182,102},{-182,-30.8889},{-118.583,-30.8889}},     color=
         {0,0,127}));
  connect(weatherProcessor.TBlaSky, mpc.weaTBlaSky) annotation (Line(points={{-247,96},
            {-186,96},{-186,-44.2222},{-118.583,-44.2222}},         color={
          0,0,127}));
  connect(weatherProcessor.TWetBul, mpc.weaTWetBul) annotation (Line(points={{-247,90},
            {-247,90},{-190,90},{-190,-57.5556},{-118.583,-57.5556}},
        color={0,0,127}));
  connect(weatherProcessor.cloTim, mpc.weaCloTim) annotation (Line(points={{-247,
            77.8},{-198,77.8},{-198,-84.2222},{-118.583,-84.2222}},
        color={0,0,127}));
  connect(weatherProcessor.solTim, mpc.weaSolTim) annotation (Line(points={{-247,
            71.8},{-202,71.8},{-202,-97.5556},{-118.583,-97.5556}},
        color={0,0,127}));
  connect(weatherProcessor.solZen, mpc.weaSolZen) annotation (Line(points={{-247,84},
            {-194,84},{-194,-70.8889},{-118.583,-70.8889}},         color={
          0,0,127}));
  connect(intGaiFra.y, gai.u)
    annotation (Line(points={{-299,210},{-282,210}}, color={0,0,127}));
  connect(intGaiFra1.y, gai1.u) annotation (Line(points={{-299,170},{-290.5,
          170},{-282,170}}, color={0,0,127}));
  connect(gai.y, deMultiplex3_1.u) annotation (Line(points={{-259,210},{-34,
          210},{242,210},{242,142},{242,128},{224,128}}, color={0,0,127}));
  connect(gai1.y, deMultiplex3_2.u) annotation (Line(points={{-259,170},{
          -259,170},{250,170},{250,58},{222,58}}, color={0,0,127}));
  connect(mpc.wesTdb, DualSetpoint.meaTDryBul_wes) annotation (Line(points={{151.292,
            -22},{240,-22},{240,-222},{-140,-222},{-140,-156},{-84,-156}},
                  color={0,0,127}));
  connect(mpc.halTdb, DualSetpoint.meaTDryBul_hal) annotation (Line(points={{151.292,
            -30.8889},{232,-30.8889},{232,-216},{-132,-216},{-132,-162},{-84,
            -162}},          color={0,0,127}));
  connect(mpc.easTdb, DualSetpoint.meaTDryBul_eas) annotation (Line(points={{151.292,
            -39.7778},{226,-39.7778},{226,-204},{-120,-204},{-120,-168},{-84,
            -168}},          color={0,0,127}));
  connect(DualSetpoint.y_wes, mpc.conHeat_wes) annotation (Line(points={{-61,
            -158},{-2.16667,-158},{-2.16667,-110.889}},   color={0,0,127}));
  connect(DualSetpoint.y_hal, mpc.conHeat_hal) annotation (Line(points={{-61,
            -162},{-61,-162},{19,-162},{19,-110.889}},   color={0,0,127}));
  connect(DualSetpoint.y_eas, mpc.conHeat_eas) annotation (Line(points={{-61,
            -166},{-61,-166},{40.1667,-166},{40.1667,-110.889}},   color={0,
          0,127}));
    annotation (Diagram(coordinateSystem(extent={{-600,-240},{280,240}})), Icon(
          coordinateSystem(extent={{-600,-240},{280,240}})),
    experiment(StopTime=604800, Interval=300),
    __Dymola_experimentSetupOutput);
  end RunMPC;

  model MPC "Open loop MPC model of the three zones"
    extends Modelica.Blocks.Icons.Block;

    replaceable package Medium = Buildings.Media.Air "Medium model";

    parameter Modelica.SIunits.Angle lon=-122*Modelica.Constants.pi/180;
    parameter Modelica.SIunits.Angle lat=38*Modelica.Constants.pi/180;
    parameter Modelica.SIunits.Time timZon=-8*3600;
    parameter Modelica.SIunits.Time modTimOffset=0;
    Modelica.Blocks.Interfaces.RealInput intRad_wes
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,180},{240,220}})));
    Modelica.Blocks.Interfaces.RealInput intCon_wes
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,150},{240,190}})));
    Modelica.Blocks.Interfaces.RealInput intLat_wes
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,120},{240,160}})));
    Modelica.Blocks.Interfaces.RealInput intRad_hal
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,80},{240,120}})));
    Modelica.Blocks.Interfaces.RealInput intCon_hal
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,50},{240,90}})));
    Modelica.Blocks.Interfaces.RealInput intLat_hal
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,20},{240,60}})));
    Modelica.Blocks.Interfaces.RealInput intRad_eas
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,-20},{240,20}})));
    Modelica.Blocks.Interfaces.RealInput intCon_eas
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,-50},{240,-10}})));
    Modelica.Blocks.Interfaces.RealInput intLat_eas
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,-80},{240,-40}})));
    RapidMPC.Modules.modExt exteas(
      lat=lat,
      A_ext=1.51,
      til=1.5707963267949,
      azi=-1.5707963267949)
      annotation (Placement(transformation(extent={{64,20},{84,40}})));
    RapidMPC.Modules.modZon eas(A_zon=13.7954)
      annotation (Placement(transformation(extent={{68,-10},{88,10}})));
    RapidMPC.Modules.modAdj adjeas(A_adj=10.22)
      annotation (Placement(transformation(extent={{34,-10},{54,10}})));
    RapidMPC.Modules.modZon hal(A_zon=9.09792)
      annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
    RapidMPC.Modules.modAdj adjwes(A_adj=10.22)
      annotation (Placement(transformation(extent={{-38,-10},{-18,10}})));
    RapidMPC.Modules.modZon wes(A_zon=13.7954)
      annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));
    RapidMPC.Modules.modExt extwes(
      lat=lat,
      A_ext=1.51,
      til=1.5707963267949,
      azi=1.5707963267949)
      annotation (Placement(transformation(extent={{-76,20},{-56,40}})));
    RapidMPC.Modules.modWin winwes(
      lat=lat,
      A_win=8.71,
      til=1.5707963267949,
      azi=1.5707963267949)
      annotation (Placement(transformation(extent={{-76,-40},{-56,-20}})));
    RapidMPC.Modules.modWin wineas(
      lat=lat,
      A_win=8.71,
      azi(displayUnit="deg") = -1.5707963267949,
      til=1.5707963267949)
      annotation (Placement(transformation(extent={{64,-40},{84,-20}})));
  protected
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Room air temperature sensor"
      annotation (Placement(transformation(extent={{-2,-64},{18,-44}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen1
    "Room air temperature sensor"
      annotation (Placement(transformation(extent={{24,-88},{44,-68}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen2
    "Room air temperature sensor"
      annotation (Placement(transformation(extent={{66,-106},{86,-86}})));
  public
    Modelica.Blocks.Interfaces.RealOutput easTdb(unit = "K")
    annotation (Placement(transformation(extent={{240,-150},{260,-130}})));
  Modelica.Blocks.Interfaces.RealOutput halTdb(unit = "K")
    annotation (Placement(transformation(extent={{240,-130},{260,-110}})));
  Modelica.Blocks.Interfaces.RealOutput wesTdb(unit = "K")
    annotation (Placement(transformation(extent={{240,-110},{260,-90}})));
    Modelica.Blocks.Interfaces.RealInput weaPAtm "Input pressure"
      annotation (Placement(transformation(extent={{-280,220},{-240,260}})));
    Modelica.Blocks.Interfaces.RealInput weaTDewPoi
    "Input dew point temperature"
    annotation (Placement(transformation(extent={{-280,190},{-240,230}})));
    Modelica.Blocks.Interfaces.RealInput weaTDryBul
    "Input dry bulb temperature"
    annotation (Placement(transformation(extent={{-280,160},{-240,200}})));
    Modelica.Blocks.Interfaces.RealInput weaRelHum
    "Input relative humidity"
    annotation (Placement(transformation(extent={{-280,130},{-240,170}})));
    Modelica.Blocks.Interfaces.RealInput weaNOpa "Input opaque sky cover"
    annotation (Placement(transformation(extent={{-280,100},{-240,140}})));
    Modelica.Blocks.Interfaces.RealInput weaCelHei "Input ceiling height"
    annotation (Placement(transformation(extent={{-280,70},{-240,110}})));
    Modelica.Blocks.Interfaces.RealInput weaNTot "Input total sky cover"
    annotation (Placement(transformation(extent={{-280,40},{-240,80}})));
    Modelica.Blocks.Interfaces.RealInput weaWinSpe "Input wind speed"
    annotation (Placement(transformation(extent={{-280,10},{-240,50}})));
    Modelica.Blocks.Interfaces.RealInput weaWinDir "Input wind direction"
    annotation (Placement(transformation(extent={{-280,-20},{-240,20}})));
    Modelica.Blocks.Interfaces.RealInput weaHHorIR
    "Input diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{-280,-50},{-240,-10}})));
    Modelica.Blocks.Interfaces.RealInput weaHDirNor
    "Input infrared horizontal radiation"
    annotation (Placement(transformation(extent={{-280,-80},{-240,-40}})));
    Modelica.Blocks.Interfaces.RealInput weaHGloHor
    "Input direct normal radiation"
    annotation (Placement(transformation(extent={{-280,-110},{-240,-70}})));
    Modelica.Blocks.Interfaces.RealInput weaHDifHor
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-140},{-240,-100}})));
    Modelica.Blocks.Interfaces.RealInput weaTBlaSky
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-170},{-240,-130}})));
    Modelica.Blocks.Interfaces.RealInput weaTWetBul
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-200},{-240,-160}})));
    Modelica.Blocks.Interfaces.RealInput weaCloTim
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-260},{-240,-220}})));
    Modelica.Blocks.Interfaces.RealInput weaSolTim
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-290},{-240,-250}})));
    Modelica.Blocks.Interfaces.RealInput weaSolZen
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-230},{-240,-190}})));
  RapidMPC.BoundaryConditions.Wea2Bus wea2Bus
      annotation (Placement(transformation(extent={{-164,138},{-120,242}})));
    Modelica.Blocks.Interfaces.RealInput conHeat_eas(unit = "1")
    "HVAC Heating Input for eas Zone" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={40,-300})));
    Modelica.Blocks.Interfaces.RealInput conHeat_hal(unit = "1")
    "HVAC Heating Input for hal Zone" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-300})));
    Modelica.Blocks.Interfaces.RealInput conHeat_wes(unit = "1")
    "HVAC Heating Input for wes Zone" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-300})));
    RapidMPC.Examples.HVAC.ConvectiveHeater convectiveHeater_wes(eff=0.99,
        q_max=1034.655)
      annotation (Placement(transformation(extent={{-60,-76},{-40,-56}})));
    RapidMPC.Examples.HVAC.ConvectiveHeater convectiveHeater_eas(eff=0.99,
        q_max=827.724)
      annotation (Placement(transformation(extent={{-60,-116},{-40,-96}})));
    Modelica.Blocks.Interfaces.RealOutput wesPhvac(unit = "W")
      annotation (Placement(transformation(extent={{240,-170},{260,-150}})));
    Modelica.Blocks.Interfaces.RealOutput easPhvac(unit = "W")
      annotation (Placement(transformation(extent={{240,-210},{260,-190}})));
    Modelica.Blocks.Math.Add3 add
    annotation (Placement(transformation(extent={{210,-250},{230,-230}})));
    Modelica.Blocks.Interfaces.RealOutput Popt(unit = "W")
      annotation (Placement(transformation(extent={{240,-250},{260,-230}})));
    RapidMPC.Examples.HVAC.ConvectiveHeater convectiveHeater_hal(eff=0.99,
        q_max=350)
      annotation (Placement(transformation(extent={{-60,-96},{-40,-76}})));
  Modelica.Blocks.Interfaces.RealOutput halPhvac(unit = "W")
    annotation (Placement(transformation(extent={{240,-190},{260,-170}})));
  equation

    // Fluid connections
    connect(extwes.porZon, wes.porZon) annotation (Line(points={{-55,30},{
          -46,30},{-46,5},{-55,5}},
                              color={191,0,0}));
    connect(wes.porZon, adjwes.porAdj) annotation (Line(points={{-55,5},{
          -42,5},{-42,0},{-39,0}},
                         color={191,0,0}));
    connect(adjwes.porZon, hal.porZon)
      annotation (Line(points={{-17,0},{19,0},{19,5}}, color={191,0,0}));
    connect(adjeas.porZon, eas.porZon)
      annotation (Line(points={{55,0},{89,0},{89,5}}, color={191,0,0}));
    connect(exteas.porZon, eas.porZon)
      annotation (Line(points={{85,30},{96,30},{96,5},{89,5}}, color={191,0,0}));

  connect(intRad_wes, wes.intRad) annotation (Line(points={{260,200},{260,
          200},{210,200},{210,174},{-44,174},{-44,62},{-88,62},{-88,-7},{
          -78,-7}}, color={0,0,127}));
  connect(intCon_wes, wes.intCon) annotation (Line(points={{260,170},{-40,
          170},{-40,58},{-84,58},{-84,7},{-78,7}}, color={0,0,127}));
  connect(intRad_hal, hal.intRad) annotation (Line(points={{260,100},{-12,
          100},{-12,-7},{-4,-7}}, color={0,0,127}));
  connect(intCon_hal, hal.intCon) annotation (Line(points={{260,70},{210,70},
          {210,104},{-8,104},{-8,7},{-4,7}}, color={0,0,127}));
  connect(intRad_eas, eas.intRad) annotation (Line(points={{260,0},{210,0},
          {210,28},{116,28},{116,16},{60,16},{60,-6},{66,-6},{66,-7}},
                                                               color={0,0,
          127}));
  connect(intCon_eas, eas.intCon) annotation (Line(points={{260,-30},{206,
          -30},{206,22},{120,22},{120,12},{62,12},{62,6},{66,6},{66,7}},
                                                                  color={0,
          0,127}));
    connect(hal.porZon, adjeas.porAdj)
      annotation (Line(points={{19,5},{19,0},{33,0}}, color={191,0,0}));
  connect(temSen.port, wes.porZon) annotation (Line(points={{-2,-54},{-2,-44},{-46,
            -44},{-46,5},{-55,5}},         color={191,0,0}));
  connect(temSen1.port, adjeas.porAdj)
    annotation (Line(points={{24,-78},{24,0},{33,0}}, color={191,0,0}));
  connect(temSen.T, wesTdb) annotation (Line(points={{18,-54},{18,-54},{96,-54},{96,
            -78},{216,-78},{216,-100},{250,-100}},           color={0,0,127}));
  connect(temSen1.T, halTdb) annotation (Line(points={{44,-78},{44,-80},{212,-80},
            {212,-120},{250,-120}},        color={0,0,127}));
  connect(eas.porZon, temSen2.port) annotation (Line(points={{89,5},{120,5},{120,-48},
            {54,-48},{54,-96},{66,-96}},         color={191,0,0}));
  connect(temSen2.T, easTdb) annotation (Line(points={{86,-96},{86,-96},{96,-96},{
            96,-82},{208,-82},{208,-140},{250,-140}},          color={0,0,
          127}));
  connect(winwes.porZon, wes.porZon) annotation (Line(points={{-55,-30},{
          -46,-30},{-46,5},{-55,5}}, color={191,0,0}));
  connect(wineas.porZon, eas.porZon) annotation (Line(points={{85,-30},{96,
          -30},{96,5},{89,5}}, color={191,0,0}));
  connect(weaPAtm, wea2Bus.weaPAtm)
    annotation (Line(points={{-260,240},{-166,240}}, color={0,0,127}));
  connect(weaTDewPoi, wea2Bus.weaTDewPoi) annotation (Line(points={{-260,
          210},{-236,210},{-236,234},{-166,234}}, color={0,0,127}));
  connect(weaTDryBul, wea2Bus.weaTDryBul) annotation (Line(points={{-260,
          180},{-234,180},{-234,228},{-166,228}}, color={0,0,127}));
  connect(weaRelHum, wea2Bus.weaRelHum) annotation (Line(points={{-260,150},
          {-232,150},{-232,222},{-166,222}}, color={0,0,127}));
  connect(weaNOpa, wea2Bus.weaNOpa) annotation (Line(points={{-260,120},{
          -230,120},{-230,216},{-166,216}}, color={0,0,127}));
  connect(weaCelHei, wea2Bus.weaCelHei) annotation (Line(points={{-260,90},
          {-228,90},{-228,210},{-166,210}}, color={0,0,127}));
  connect(weaNTot, wea2Bus.weaNTot) annotation (Line(points={{-260,60},{
          -226,60},{-226,204},{-166,204}}, color={0,0,127}));
  connect(weaWinSpe, wea2Bus.weaWinSpe) annotation (Line(points={{-260,30},
          {-224,30},{-224,198},{-166,198}}, color={0,0,127}));
  connect(weaWinDir, wea2Bus.weaWinDir) annotation (Line(points={{-260,0},{
          -222,0},{-222,192},{-166,192}}, color={0,0,127}));
  connect(weaHHorIR, wea2Bus.weaHHorIR) annotation (Line(points={{-260,-30},
          {-220,-30},{-220,186},{-166,186}}, color={0,0,127}));
  connect(weaHDirNor, wea2Bus.weaHDirNor) annotation (Line(points={{-260,
          -60},{-218,-60},{-218,180},{-166,180}}, color={0,0,127}));
  connect(weaHGloHor, wea2Bus.weaHGloHor) annotation (Line(points={{-260,
          -90},{-216,-90},{-216,174},{-166,174}}, color={0,0,127}));
  connect(weaHDifHor, wea2Bus.weaHDifHor) annotation (Line(points={{-260,
          -120},{-214,-120},{-214,168},{-166,168}}, color={0,0,127}));
  connect(weaTBlaSky, wea2Bus.weaTBlaSky) annotation (Line(points={{-260,
          -150},{-212,-150},{-212,162.2},{-166,162.2}}, color={0,0,127}));
  connect(weaTWetBul, wea2Bus.weaTWetBul) annotation (Line(points={{-260,
          -180},{-210,-180},{-210,156},{-166,156}}, color={0,0,127}));
  connect(weaSolZen, wea2Bus.weaSolZen) annotation (Line(points={{-260,-210},
          {-208,-210},{-208,149.8},{-166,149.8}}, color={0,0,127}));
  connect(weaCloTim, wea2Bus.weaCloTim) annotation (Line(points={{-260,-240},
          {-206,-240},{-206,144},{-166,144}}, color={0,0,127}));
  connect(weaSolTim, wea2Bus.weaSolTim) annotation (Line(points={{-260,-270},
          {-204,-270},{-204,138},{-166,138}}, color={0,0,127}));
  connect(wea2Bus.weaBus, extwes.weaBus) annotation (Line(
      points={{-120,190},{-114,190},{-110,190},{-110,30},{-77,30}},
      color={255,204,51},
      thickness=0.5));
  connect(wea2Bus.weaBus, winwes.weaBus) annotation (Line(
      points={{-120,190},{-110,190},{-110,-30},{-77,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(wea2Bus.weaBus, wineas.weaBus) annotation (Line(
      points={{-120,190},{-110,190},{-110,40},{28,40},{28,-30},{63,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(wea2Bus.weaBus, exteas.weaBus) annotation (Line(
      points={{-120,190},{-110,190},{-110,40},{28,40},{28,30},{63,30}},
      color={255,204,51},
      thickness=0.5));
    connect(convectiveHeater_wes.HeatOutput, wes.porZon) annotation (Line(points={
            {-39.6,-66},{-24,-66},{-24,-16},{-46,-16},{-46,5},{-55,5}}, color={191,
            0,0}));
    connect(convectiveHeater_eas.HeatOutput, eas.porZon) annotation (Line(points={
            {-39.6,-106},{-24,-106},{-12,-106},{-12,-16},{46,-16},{96,-16},{96,5},
            {89,5}}, color={191,0,0}));
    connect(conHeat_wes, convectiveHeater_wes.u) annotation (Line(points={{-40,-300},
            {-40,-300},{-40,-180},{-40,-176},{-102,-176},{-102,-66},{-62,-66}},
          color={0,0,127}));
    connect(conHeat_eas, convectiveHeater_eas.u) annotation (Line(points={{40,-300},
            {40,-300},{40,-160},{40,-154},{-94,-154},{-94,-106},{-62,-106}},
          color={0,0,127}));
    connect(convectiveHeater_wes.P_e, wesPhvac) annotation (Line(points={{-39,-72},
            {-2,-72},{-2,-110},{110,-110},{110,-86},{184,-86},{184,-160},{250,-160}},
          color={0,0,127}));
    connect(convectiveHeater_eas.P_e, easPhvac) annotation (Line(points={{-39,-112},
            {-39,-112},{-10,-112},{-10,-118},{114,-118},{114,-90},{176,-90},{176,-200},
            {250,-200}}, color={0,0,127}));
  connect(add.y, Popt)
    annotation (Line(points={{231,-240},{250,-240}}, color={0,0,127}));
  connect(add.u1, wesPhvac) annotation (Line(points={{208,-232},{184,-232},
          {184,-160},{250,-160}}, color={0,0,127}));
  connect(conHeat_hal, convectiveHeater_hal.u) annotation (Line(points={{0,
          -300},{0,-300},{0,-166},{0,-164},{-98,-164},{-98,-86},{-62,-86}},
        color={0,0,127}));
  connect(convectiveHeater_hal.P_e, halPhvac) annotation (Line(points={{-39,
          -92},{-6,-92},{-6,-114},{112,-114},{112,-88},{180,-88},{180,-180},
          {250,-180}}, color={0,0,127}));
  connect(add.u2, halPhvac) annotation (Line(points={{208,-240},{180,-240},
          {180,-180},{250,-180}}, color={0,0,127}));
  connect(add.u3, easPhvac) annotation (Line(points={{208,-248},{176,-248},
          {176,-200},{250,-200}}, color={0,0,127}));
  connect(convectiveHeater_hal.HeatOutput, adjeas.porAdj) annotation (Line(
        points={{-39.6,-86},{-18,-86},{-18,-14},{24,-14},{24,0},{33,0}},
        color={191,0,0}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -280},{240,260}}),   graphics={
          Rectangle(
            extent={{-130,124},{138,-122}},
            lineColor={0,0,0},
            lineThickness=1,
            fillPattern=FillPattern.Solid,
            fillColor={255,255,255}),
          Text(
            extent={{64,-122},{136,-138}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
          textString="Reduced Order Model"),
          Text(
            extent={{-164,134},{-120,122}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="Weather Input",
            fontSize=12),
          Rectangle(
            extent={{-118,132},{-102,114}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-50,132},{-34,114}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-32,136},{46,122}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
            textString="Internal Load West Input"),
          Rectangle(
            extent={{-8,9},{8,-9}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={138,103},
            rotation=90),
          Text(
            extent={{138,122},{216,108}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
            textString="Internal Load Hall Input"),
          Text(
            extent={{138,44},{216,30}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
            textString="Internal Load East Input"),
          Rectangle(
            extent={{-8,9},{8,-9}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={138,25},
            rotation=90),
          Rectangle(
            extent={{-11.5,9.5},{11.5,-9.5}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={137.5,-84.5},
            rotation=90),
          Text(
            extent={{138,-62},{216,-76}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
          textString="Measurement Outputs"),
          Rectangle(
            extent={{-8,9},{8,-9}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={-98,-123},
            rotation=180),
          Text(
            extent={{-96,-124},{-20,-136}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
            textString="Control Signals")}),
                                  Icon(coordinateSystem(preserveAspectRatio=false,
            extent={{-240,-280},{240,260}}),
                                       graphics={
        Rectangle(
          extent={{-240,260},{240,-280}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-80,-30},{80,26}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-74,18},{-24,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{-80,16},{-74,-18}},
            lineColor={95,95,95},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-78,16},{-76,-18}},
            lineColor={95,95,95},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{24,18},{74,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{-16,18},{16,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{74,16},{80,-18}},
            lineColor={95,95,95},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{76,16},{78,-18}},
            lineColor={95,95,95},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{20,100},{96,68}},
            lineColor={0,0,127},
            textString="TRoo"),
          Text(
            extent={{20,74},{96,42}},
            lineColor={0,0,127},
            textString="Xi"),
          Text(
            extent={{22,-44},{98,-76}},
            lineColor={0,0,127},
            textString="HDirWin")}));
  end MPC;

  model MPC_eas "Open loop MPC model of the three zones"
    extends Modelica.Blocks.Icons.Block;

    replaceable package Medium = Buildings.Media.Air "Medium model";

    parameter Modelica.SIunits.Angle lon=-122*Modelica.Constants.pi/180;
    parameter Modelica.SIunits.Angle lat=38*Modelica.Constants.pi/180;
    parameter Modelica.SIunits.Time timZon=-8*3600;
    parameter Modelica.SIunits.Time modTimOffset=0;
    Modelica.Blocks.Interfaces.RealInput intRad_eas
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,-20},{240,20}})));
    Modelica.Blocks.Interfaces.RealInput intCon_eas
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,-50},{240,-10}})));
    Modelica.Blocks.Interfaces.RealInput intLat_eas
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,-80},{240,-40}})));
    RapidMPC.Modules.modExt exteas(
      lat=lat,
      A_ext=1.51,
      til=1.5707963267949,
      azi=-1.5707963267949)
      annotation (Placement(transformation(extent={{64,20},{84,40}})));
    RapidMPC.Modules.modZon eas(A_zon=13.7954)
      annotation (Placement(transformation(extent={{68,-10},{88,10}})));
    RapidMPC.Modules.modAdj adjeas(A_adj=10.22)
      annotation (Placement(transformation(extent={{34,-10},{54,10}})));
    RapidMPC.Modules.modWin wineas(
      lat=lat,
      A_win=8.71,
      azi(displayUnit="deg") = -1.5707963267949,
      til=1.5707963267949)
      annotation (Placement(transformation(extent={{64,-38},{84,-18}})));
  protected
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen2
    "Room air temperature sensor"
      annotation (Placement(transformation(extent={{66,-108},{86,-88}})));
  public
  Modelica.Blocks.Interfaces.RealOutput easTdb
    annotation (Placement(transformation(extent={{240,-150},{260,-130}})));
    Modelica.Blocks.Interfaces.RealInput halTdb
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-320},{-240,-280}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preEal
    annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
    Modelica.Blocks.Interfaces.RealInput weaPAtm "Input pressure"
      annotation (Placement(transformation(extent={{-280,220},{-240,260}})));
    Modelica.Blocks.Interfaces.RealInput weaTDewPoi
    "Input dew point temperature"
    annotation (Placement(transformation(extent={{-280,190},{-240,230}})));
    Modelica.Blocks.Interfaces.RealInput weaTDryBul
    "Input dry bulb temperature"
    annotation (Placement(transformation(extent={{-280,160},{-240,200}})));
    Modelica.Blocks.Interfaces.RealInput weaRelHum
    "Input relative humidity"
    annotation (Placement(transformation(extent={{-280,130},{-240,170}})));
    Modelica.Blocks.Interfaces.RealInput weaNOpa "Input opaque sky cover"
    annotation (Placement(transformation(extent={{-280,100},{-240,140}})));
    Modelica.Blocks.Interfaces.RealInput weaCelHei "Input ceiling height"
    annotation (Placement(transformation(extent={{-280,70},{-240,110}})));
    Modelica.Blocks.Interfaces.RealInput weaNTot "Input total sky cover"
    annotation (Placement(transformation(extent={{-280,40},{-240,80}})));
    Modelica.Blocks.Interfaces.RealInput weaWinSpe "Input wind speed"
    annotation (Placement(transformation(extent={{-280,10},{-240,50}})));
    Modelica.Blocks.Interfaces.RealInput weaWinDir "Input wind direction"
    annotation (Placement(transformation(extent={{-280,-20},{-240,20}})));
    Modelica.Blocks.Interfaces.RealInput weaHHorIR
    "Input diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{-280,-50},{-240,-10}})));
    Modelica.Blocks.Interfaces.RealInput weaHDirNor
    "Input infrared horizontal radiation"
    annotation (Placement(transformation(extent={{-280,-80},{-240,-40}})));
    Modelica.Blocks.Interfaces.RealInput weaHGloHor
    "Input direct normal radiation"
    annotation (Placement(transformation(extent={{-280,-110},{-240,-70}})));
    Modelica.Blocks.Interfaces.RealInput weaHDifHor
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-140},{-240,-100}})));
    Modelica.Blocks.Interfaces.RealInput weaTBlaSky
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-170},{-240,-130}})));
    Modelica.Blocks.Interfaces.RealInput weaTWetBul
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-200},{-240,-160}})));
    Modelica.Blocks.Interfaces.RealInput weaCloTim
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-260},{-240,-220}})));
    Modelica.Blocks.Interfaces.RealInput weaSolTim
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-290},{-240,-250}})));
    Modelica.Blocks.Interfaces.RealInput weaSolZen
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-230},{-240,-190}})));
  RapidMPC.BoundaryConditions.Wea2Bus wea2Bus
      annotation (Placement(transformation(extent={{-164,138},{-120,242}})));
  equation

    // Fluid connections
    connect(adjeas.porZon, eas.porZon)
      annotation (Line(points={{55,0},{89,0},{89,5}}, color={191,0,0}));
    connect(exteas.porZon, eas.porZon)
      annotation (Line(points={{85,30},{96,30},{96,5},{89,5}}, color={191,0,0}));

  connect(intRad_eas, eas.intRad) annotation (Line(points={{260,0},{210,0},
          {210,28},{116,28},{116,16},{60,16},{60,-6},{66,-6},{66,-7}},
                                                               color={0,0,
          127}));
  connect(intCon_eas, eas.intCon) annotation (Line(points={{260,-30},{206,
          -30},{206,22},{120,22},{120,12},{62,12},{62,6},{66,6},{66,7}},
                                                                  color={0,
          0,127}));
  connect(eas.porZon, temSen2.port) annotation (Line(points={{89,5},{120,5},
          {120,-48},{54,-48},{54,-98},{66,-98}}, color={191,0,0}));
  connect(temSen2.T, easTdb) annotation (Line(points={{86,-98},{86,-96},{
          114,-96},{114,-82},{208,-82},{208,-140},{250,-140}}, color={0,0,
          127}));
  connect(wineas.porZon, eas.porZon) annotation (Line(points={{85,-28},{96,
          -28},{96,5},{89,5}}, color={191,0,0}));
  connect(halTdb, preEal.T) annotation (Line(points={{-260,-300},{-142,-300},
          {-142,0},{-4,0}}, color={0,0,127}));
  connect(preEal.port, adjeas.porAdj)
    annotation (Line(points={{18,0},{33,0}}, color={191,0,0}));
  connect(weaPAtm, wea2Bus.weaPAtm) annotation (Line(points={{-260,240},{
          -214,240},{-166,240}}, color={0,0,127}));
  connect(weaTDewPoi, wea2Bus.weaTDewPoi) annotation (Line(points={{-260,
          210},{-236,210},{-236,234},{-166,234}}, color={0,0,127}));
  connect(weaTDryBul, wea2Bus.weaTDryBul) annotation (Line(points={{-260,
          180},{-234,180},{-234,228},{-166,228}}, color={0,0,127}));
  connect(weaRelHum, wea2Bus.weaRelHum) annotation (Line(points={{-260,150},
          {-232,150},{-232,222},{-166,222}}, color={0,0,127}));
  connect(weaNOpa, wea2Bus.weaNOpa) annotation (Line(points={{-260,120},{
          -230,120},{-230,216},{-166,216}}, color={0,0,127}));
  connect(weaCelHei, wea2Bus.weaCelHei) annotation (Line(points={{-260,90},
          {-228,90},{-228,210},{-166,210}}, color={0,0,127}));
  connect(weaNTot, wea2Bus.weaNTot) annotation (Line(points={{-260,60},{
          -226,60},{-226,204},{-166,204}}, color={0,0,127}));
  connect(weaWinSpe, wea2Bus.weaWinSpe) annotation (Line(points={{-260,30},
          {-224,30},{-224,198},{-166,198}}, color={0,0,127}));
  connect(weaWinDir, wea2Bus.weaWinDir) annotation (Line(points={{-260,0},{
          -222,0},{-222,192},{-166,192}}, color={0,0,127}));
  connect(weaHHorIR, wea2Bus.weaHHorIR) annotation (Line(points={{-260,-30},
          {-220,-30},{-220,186},{-166,186}}, color={0,0,127}));
  connect(weaHDirNor, wea2Bus.weaHDirNor) annotation (Line(points={{-260,
          -60},{-218,-60},{-218,180},{-166,180}}, color={0,0,127}));
  connect(weaHGloHor, wea2Bus.weaHGloHor) annotation (Line(points={{-260,
          -90},{-216,-90},{-216,174},{-166,174}}, color={0,0,127}));
  connect(weaHDifHor, wea2Bus.weaHDifHor) annotation (Line(points={{-260,
          -120},{-214,-120},{-214,168},{-166,168}}, color={0,0,127}));
  connect(weaTBlaSky, wea2Bus.weaTBlaSky) annotation (Line(points={{-260,
          -150},{-212,-150},{-212,162.2},{-166,162.2}}, color={0,0,127}));
  connect(weaTWetBul, wea2Bus.weaTWetBul) annotation (Line(points={{-260,
          -180},{-210,-180},{-210,156},{-166,156}}, color={0,0,127}));
  connect(weaSolZen, wea2Bus.weaSolZen) annotation (Line(points={{-260,-210},
          {-208,-210},{-208,149.8},{-166,149.8}}, color={0,0,127}));
  connect(weaCloTim, wea2Bus.weaCloTim) annotation (Line(points={{-260,-240},
          {-206,-240},{-206,144},{-166,144}}, color={0,0,127}));
  connect(weaSolTim, wea2Bus.weaSolTim) annotation (Line(points={{-260,-270},
          {-204,-270},{-204,138},{-166,138}}, color={0,0,127}));
  connect(wea2Bus.weaBus, exteas.weaBus) annotation (Line(
      points={{-120,190},{-114,190},{-108,190},{-108,30},{63,30}},
      color={255,204,51},
      thickness=0.5));
  connect(wea2Bus.weaBus, wineas.weaBus) annotation (Line(
      points={{-120,190},{-114,190},{-108,190},{-108,-28},{63,-28}},
      color={255,204,51},
      thickness=0.5));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -320},{240,260}}),   graphics={
          Rectangle(
            extent={{-130,124},{138,-122}},
            lineColor={0,0,0},
            lineThickness=1,
            fillPattern=FillPattern.Solid,
            fillColor={255,255,255}),
          Text(
            extent={{-130,-122},{-58,-138}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="Simulation Model"),
          Rectangle(
            extent={{-118,132},{-102,114}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{138,44},{216,30}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
            textString="Internal Load East Input"),
          Rectangle(
            extent={{-8,9},{8,-9}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={138,25},
            rotation=90),
          Rectangle(
            extent={{-8,9},{8,-9}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={138,-81},
            rotation=90),
          Text(
            extent={{138,-62},{216,-76}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
          textString="Measurement Outputs"),
          Rectangle(
            extent={{-8,9},{8,-9}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={-130,1},
            rotation=90),
          Text(
            extent={{-176,22},{-132,10}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=11,
          textString="Adjacent Input"),
          Text(
            extent={{-100,144},{-56,132}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="Weather Input",
            fontSize=12)}),       Icon(coordinateSystem(preserveAspectRatio=false,
            extent={{-240,-320},{240,260}}),
                                       graphics={
          Rectangle(
            extent={{-80,-30},{80,26}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-74,18},{-24,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{-80,16},{-74,-18}},
            lineColor={95,95,95},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-78,16},{-76,-18}},
            lineColor={95,95,95},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{24,18},{74,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{-16,18},{16,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{74,16},{80,-18}},
            lineColor={95,95,95},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{76,16},{78,-18}},
            lineColor={95,95,95},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{20,100},{96,68}},
            lineColor={0,0,127},
            textString="TRoo"),
          Text(
            extent={{20,74},{96,42}},
            lineColor={0,0,127},
            textString="Xi"),
          Text(
            extent={{22,-44},{98,-76}},
            lineColor={0,0,127},
            textString="HDirWin")}));
  end MPC_eas;

  model MPC_wes "Open loop MPC model of the three zones"
    extends Modelica.Blocks.Icons.Block;

    replaceable package Medium = Buildings.Media.Air "Medium model";

    parameter Modelica.SIunits.Angle lon=-122*Modelica.Constants.pi/180;
    parameter Modelica.SIunits.Angle lat=38*Modelica.Constants.pi/180;
    parameter Modelica.SIunits.Time timZon=-8*3600;
    parameter Modelica.SIunits.Time modTimOffset=0;
    Modelica.Blocks.Interfaces.RealInput intRad_wes
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,180},{240,220}})));
    Modelica.Blocks.Interfaces.RealInput intCon_wes
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,150},{240,190}})));
    Modelica.Blocks.Interfaces.RealInput intLat_wes
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,120},{240,160}})));
    RapidMPC.Modules.modAdj adjwes(A_adj=10.22)
      annotation (Placement(transformation(extent={{-38,-10},{-18,10}})));
    RapidMPC.Modules.modZon wes(A_zon=13.7954)
      annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));
    RapidMPC.Modules.modExt extwes(
      lat=lat,
      A_ext=1.51,
      til=1.5707963267949,
      azi=1.5707963267949)
      annotation (Placement(transformation(extent={{-76,20},{-56,40}})));
    RapidMPC.Modules.modWin winwes(
      lat=lat,
      A_win=8.71,
      til=1.5707963267949,
      azi=1.5707963267949)
      annotation (Placement(transformation(extent={{-76,-40},{-56,-20}})));
  protected
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Room air temperature sensor"
      annotation (Placement(transformation(extent={{-38,-52},{-18,-32}})));
  public
  Modelica.Blocks.Interfaces.RealOutput wesTdb
    annotation (Placement(transformation(extent={{240,-110},{260,-90}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preWes
    annotation (Placement(transformation(extent={{18,-10},{-2,10}})));
    Modelica.Blocks.Interfaces.RealInput halTdb
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-322},{-240,-282}})));
    Modelica.Blocks.Interfaces.RealInput weaPAtm "Input pressure"
      annotation (Placement(transformation(extent={{-280,220},{-240,260}})));
    Modelica.Blocks.Interfaces.RealInput weaTDewPoi
    "Input dew point temperature"
    annotation (Placement(transformation(extent={{-280,190},{-240,230}})));
    Modelica.Blocks.Interfaces.RealInput weaTDryBul
    "Input dry bulb temperature"
    annotation (Placement(transformation(extent={{-280,160},{-240,200}})));
    Modelica.Blocks.Interfaces.RealInput weaRelHum
    "Input relative humidity"
    annotation (Placement(transformation(extent={{-280,130},{-240,170}})));
    Modelica.Blocks.Interfaces.RealInput weaNOpa "Input opaque sky cover"
    annotation (Placement(transformation(extent={{-280,100},{-240,140}})));
    Modelica.Blocks.Interfaces.RealInput weaCelHei "Input ceiling height"
    annotation (Placement(transformation(extent={{-280,70},{-240,110}})));
    Modelica.Blocks.Interfaces.RealInput weaNTot "Input total sky cover"
    annotation (Placement(transformation(extent={{-280,40},{-240,80}})));
    Modelica.Blocks.Interfaces.RealInput weaWinSpe "Input wind speed"
    annotation (Placement(transformation(extent={{-280,10},{-240,50}})));
    Modelica.Blocks.Interfaces.RealInput weaWinDir "Input wind direction"
    annotation (Placement(transformation(extent={{-280,-20},{-240,20}})));
    Modelica.Blocks.Interfaces.RealInput weaHHorIR
    "Input diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{-280,-50},{-240,-10}})));
    Modelica.Blocks.Interfaces.RealInput weaHDirNor
    "Input infrared horizontal radiation"
    annotation (Placement(transformation(extent={{-280,-80},{-240,-40}})));
    Modelica.Blocks.Interfaces.RealInput weaHGloHor
    "Input direct normal radiation"
    annotation (Placement(transformation(extent={{-280,-110},{-240,-70}})));
    Modelica.Blocks.Interfaces.RealInput weaHDifHor
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-140},{-240,-100}})));
    Modelica.Blocks.Interfaces.RealInput weaTBlaSky
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-170},{-240,-130}})));
    Modelica.Blocks.Interfaces.RealInput weaTWetBul
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-200},{-240,-160}})));
    Modelica.Blocks.Interfaces.RealInput weaCloTim
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-260},{-240,-220}})));
    Modelica.Blocks.Interfaces.RealInput weaSolTim
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-290},{-240,-250}})));
    Modelica.Blocks.Interfaces.RealInput weaSolZen
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-230},{-240,-190}})));
  RapidMPC.BoundaryConditions.Wea2Bus wea2Bus
      annotation (Placement(transformation(extent={{-164,138},{-120,242}})));
  equation

    // Fluid connections
    connect(extwes.porZon, wes.porZon) annotation (Line(points={{-55,30},{
          -46,30},{-46,5},{-55,5}},
                              color={191,0,0}));
    connect(wes.porZon, adjwes.porAdj) annotation (Line(points={{-55,5},{
          -42,5},{-42,0},{-39,0}},
                         color={191,0,0}));

  connect(intRad_wes, wes.intRad) annotation (Line(points={{260,200},{260,
          200},{210,200},{210,174},{-44,174},{-44,62},{-88,62},{-88,-7},{
          -78,-7}}, color={0,0,127}));
  connect(intCon_wes, wes.intCon) annotation (Line(points={{260,170},{-40,
          170},{-40,58},{-84,58},{-84,7},{-78,7}}, color={0,0,127}));
  connect(temSen.port, wes.porZon) annotation (Line(points={{-38,-42},{-44,
          -42},{-46,-42},{-46,5},{-55,5}}, color={191,0,0}));
  connect(temSen.T, wesTdb) annotation (Line(points={{-18,-42},{-18,-54},{
          114,-54},{114,-78},{216,-78},{216,-100},{250,-100}},
                                                             color={0,0,127}));
  connect(winwes.porZon, wes.porZon) annotation (Line(points={{-55,-30},{
          -46,-30},{-46,5},{-55,5}}, color={191,0,0}));
  connect(adjwes.porZon, preWes.port)
    annotation (Line(points={{-17,0},{-2,0},{-2,0}}, color={191,0,0}));
  connect(halTdb, preWes.T) annotation (Line(points={{-260,-302},{-142,-302},
          {-142,48},{42,48},{42,0},{20,0}}, color={0,0,127}));
  connect(weaPAtm, wea2Bus.weaPAtm)
    annotation (Line(points={{-260,240},{-166,240}}, color={0,0,127}));
  connect(weaTDewPoi, wea2Bus.weaTDewPoi) annotation (Line(points={{-260,
          210},{-236,210},{-236,234},{-166,234}}, color={0,0,127}));
  connect(weaTDryBul, wea2Bus.weaTDryBul) annotation (Line(points={{-260,
          180},{-234,180},{-234,228},{-166,228}}, color={0,0,127}));
  connect(weaRelHum, wea2Bus.weaRelHum) annotation (Line(points={{-260,150},
          {-232,150},{-232,222},{-166,222}}, color={0,0,127}));
  connect(weaNOpa, wea2Bus.weaNOpa) annotation (Line(points={{-260,120},{
          -230,120},{-230,216},{-166,216}}, color={0,0,127}));
  connect(weaCelHei, wea2Bus.weaCelHei) annotation (Line(points={{-260,90},
          {-228,90},{-228,210},{-166,210}}, color={0,0,127}));
  connect(weaNTot, wea2Bus.weaNTot) annotation (Line(points={{-260,60},{
          -226,60},{-226,204},{-166,204}}, color={0,0,127}));
  connect(weaWinSpe, wea2Bus.weaWinSpe) annotation (Line(points={{-260,30},
          {-224,30},{-224,198},{-166,198}}, color={0,0,127}));
  connect(weaWinDir, wea2Bus.weaWinDir) annotation (Line(points={{-260,0},{
          -222,0},{-222,192},{-166,192}}, color={0,0,127}));
  connect(weaHHorIR, wea2Bus.weaHHorIR) annotation (Line(points={{-260,-30},
          {-220,-30},{-220,186},{-166,186}}, color={0,0,127}));
  connect(weaHDirNor, wea2Bus.weaHDirNor) annotation (Line(points={{-260,
          -60},{-218,-60},{-218,180},{-166,180}}, color={0,0,127}));
  connect(weaHGloHor, wea2Bus.weaHGloHor) annotation (Line(points={{-260,
          -90},{-216,-90},{-216,174},{-166,174}}, color={0,0,127}));
  connect(weaHDifHor, wea2Bus.weaHDifHor) annotation (Line(points={{-260,
          -120},{-214,-120},{-214,168},{-166,168}}, color={0,0,127}));
  connect(weaTBlaSky, wea2Bus.weaTBlaSky) annotation (Line(points={{-260,
          -150},{-212,-150},{-212,162.2},{-166,162.2}}, color={0,0,127}));
  connect(weaTWetBul, wea2Bus.weaTWetBul) annotation (Line(points={{-260,
          -180},{-210,-180},{-210,156},{-166,156}}, color={0,0,127}));
  connect(weaSolZen, wea2Bus.weaSolZen) annotation (Line(points={{-260,-210},
          {-208,-210},{-208,149.8},{-166,149.8}}, color={0,0,127}));
  connect(weaCloTim, wea2Bus.weaCloTim) annotation (Line(points={{-260,-240},
          {-206,-240},{-206,144},{-166,144}}, color={0,0,127}));
  connect(weaSolTim, wea2Bus.weaSolTim) annotation (Line(points={{-260,-270},
          {-204,-270},{-204,138},{-166,138}}, color={0,0,127}));
  connect(wea2Bus.weaBus, extwes.weaBus) annotation (Line(
      points={{-120,190},{-110,190},{-110,30},{-77,30}},
      color={255,204,51},
      thickness=0.5));
  connect(wea2Bus.weaBus, winwes.weaBus) annotation (Line(
      points={{-120,190},{-110,190},{-110,-30},{-77,-30}},
      color={255,204,51},
      thickness=0.5));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -320},{240,260}}),   graphics={
          Rectangle(
            extent={{-130,124},{138,-122}},
            lineColor={0,0,0},
            lineThickness=1,
            fillPattern=FillPattern.Solid,
            fillColor={255,255,255}),
          Text(
            extent={{-130,-122},{-58,-138}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="Simulation Model"),
          Text(
            extent={{-164,134},{-120,122}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="Weather Input",
            fontSize=12),
          Rectangle(
            extent={{-118,132},{-102,114}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-50,132},{-34,114}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-32,136},{46,122}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
            textString="Internal Load West Input"),
          Rectangle(
            extent={{-8,9},{8,-9}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={138,-81},
            rotation=90),
          Text(
            extent={{138,-62},{216,-76}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
          textString="Measurement Outputs"),
          Rectangle(
            extent={{-8,9},{8,-9}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={-130,49},
            rotation=90),
          Text(
            extent={{-176,70},{-132,58}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=11,
          textString="Adjacent Input"),
          Text(
            extent={{-164,134},{-120,122}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="Weather Input",
            fontSize=12)}),       Icon(coordinateSystem(preserveAspectRatio=false,
            extent={{-240,-320},{240,260}}),
                                       graphics={
          Rectangle(
            extent={{-80,-30},{80,26}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-74,18},{-24,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{-80,16},{-74,-18}},
            lineColor={95,95,95},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-78,16},{-76,-18}},
            lineColor={95,95,95},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{24,18},{74,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{-16,18},{16,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{74,16},{80,-18}},
            lineColor={95,95,95},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{76,16},{78,-18}},
            lineColor={95,95,95},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{20,100},{96,68}},
            lineColor={0,0,127},
            textString="TRoo"),
          Text(
            extent={{20,74},{96,42}},
            lineColor={0,0,127},
            textString="Xi"),
          Text(
            extent={{22,-44},{98,-76}},
            lineColor={0,0,127},
            textString="HDirWin")}));
  end MPC_wes;

  model MPC_hal "Open loop MPC model of the three zones"
    extends Modelica.Blocks.Icons.Block;

    replaceable package Medium = Buildings.Media.Air "Medium model";

    parameter Modelica.SIunits.Angle lon=-122*Modelica.Constants.pi/180;
    parameter Modelica.SIunits.Angle lat=38*Modelica.Constants.pi/180;
    parameter Modelica.SIunits.Time timZon=-8*3600;
    parameter Modelica.SIunits.Time modTimOffset=0;
    Modelica.Blocks.Interfaces.RealInput intRad_hal
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,80},{240,120}})));
    Modelica.Blocks.Interfaces.RealInput intCon_hal
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,50},{240,90}})));
    Modelica.Blocks.Interfaces.RealInput intLat_hal
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,20},{240,60}})));
    RapidMPC.Modules.modAdj adjeas(A_adj=10.22)
      annotation (Placement(transformation(extent={{34,-10},{54,10}})));
    RapidMPC.Modules.modZon hal(A_zon=9.09792)
      annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
    RapidMPC.Modules.modAdj adjwes(A_adj=10.22)
      annotation (Placement(transformation(extent={{-38,-10},{-18,10}})));
  protected
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen1
    "Room air temperature sensor"
      annotation (Placement(transformation(extent={{24,-90},{44,-70}})));
  public
  Modelica.Blocks.Interfaces.RealOutput halTdb
    annotation (Placement(transformation(extent={{240,-130},{260,-110}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preWes
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature preEas
    annotation (Placement(transformation(extent={{86,-10},{66,10}})));
    Modelica.Blocks.Interfaces.RealInput wesTdb
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-320},{-240,-280}})));
    Modelica.Blocks.Interfaces.RealInput easTdb
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-350},{-240,-310}})));
  equation

    // Fluid connections
    connect(adjwes.porZon, hal.porZon)
      annotation (Line(points={{-17,0},{19,0},{19,5}}, color={191,0,0}));

  connect(intRad_hal, hal.intRad) annotation (Line(points={{260,100},{-12,
          100},{-12,-7},{-4,-7}}, color={0,0,127}));
  connect(intCon_hal, hal.intCon) annotation (Line(points={{260,70},{210,70},
          {210,104},{-8,104},{-8,7},{-4,7}}, color={0,0,127}));
    connect(hal.porZon, adjeas.porAdj)
      annotation (Line(points={{19,5},{19,0},{33,0}}, color={191,0,0}));
  connect(temSen1.port, adjeas.porAdj)
    annotation (Line(points={{24,-80},{24,0},{33,0}}, color={191,0,0}));
  connect(temSen1.T, halTdb) annotation (Line(points={{44,-80},{44,-80},{
          212,-80},{212,-120},{250,-120}}, color={0,0,127}));
  connect(preWes.port, adjwes.porAdj)
    annotation (Line(points={{-50,0},{-39,0},{-39,0}}, color={191,0,0}));
  connect(preEas.port, adjeas.porZon)
    annotation (Line(points={{66,0},{55,0},{55,0}}, color={191,0,0}));
  connect(wesTdb, preWes.T) annotation (Line(points={{-260,-300},{-142,-300},
          {-142,50},{-96,50},{-96,0},{-72,0}}, color={0,0,127}));
  connect(easTdb, preEas.T) annotation (Line(points={{-260,-330},{-198,-330},
          {-140,-330},{-140,46},{-98,46},{-98,-18},{98,-18},{98,0},{88,0}},
        color={0,0,127}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
              -220},{240,220}}), graphics={
          Rectangle(
            extent={{-130,124},{138,-122}},
            lineColor={0,0,0},
            lineThickness=1,
            fillPattern=FillPattern.Solid,
            fillColor={255,255,255}),
          Text(
            extent={{-130,-122},{-58,-138}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="Simulation Model"),
          Text(
            extent={{-164,134},{-120,122}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="Weather Input",
            fontSize=12),
          Rectangle(
            extent={{-118,132},{-102,114}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-8,9},{8,-9}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={138,103},
            rotation=90),
          Text(
            extent={{138,122},{216,108}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
            textString="Internal Load Hall Input"),
          Rectangle(
            extent={{-8,9},{8,-9}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={138,-81},
            rotation=90),
          Text(
            extent={{138,-62},{216,-76}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
          textString="Measurement Outputs"),
          Rectangle(
            extent={{-8,9},{8,-9}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={-130,49},
            rotation=90),
          Text(
            extent={{-176,70},{-132,58}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=11,
          textString="Adjacent Input")}),
                                  Icon(coordinateSystem(preserveAspectRatio=false,
            extent={{-240,-220},{240,220}}),
                                       graphics={
          Rectangle(
            extent={{-80,-30},{80,26}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-74,18},{-24,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{-80,16},{-74,-18}},
            lineColor={95,95,95},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-78,16},{-76,-18}},
            lineColor={95,95,95},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{24,18},{74,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{-16,18},{16,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{74,16},{80,-18}},
            lineColor={95,95,95},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{76,16},{78,-18}},
            lineColor={95,95,95},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{20,100},{96,68}},
            lineColor={0,0,127},
            textString="TRoo"),
          Text(
            extent={{20,74},{96,42}},
            lineColor={0,0,127},
            textString="Xi"),
          Text(
            extent={{22,-44},{98,-76}},
            lineColor={0,0,127},
            textString="HDirWin")}));
  end MPC_hal;

  model MPC_wAdapativeWindow
  "Open loop MPC model of the three zones with adaptive window model and new weather inputs"
    extends Modelica.Blocks.Icons.Block;

    replaceable package Medium = Buildings.Media.Air "Medium model";

    parameter Modelica.SIunits.Angle lon=-122*Modelica.Constants.pi/180;
    parameter Modelica.SIunits.Angle lat=38*Modelica.Constants.pi/180;
    parameter Modelica.SIunits.Time timZon=-8*3600;
    parameter Modelica.SIunits.Time modTimOffset=0;
    Modelica.Blocks.Interfaces.RealInput intRad_wes
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,180},{240,220}})));
    Modelica.Blocks.Interfaces.RealInput intCon_wes
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,150},{240,190}})));
    Modelica.Blocks.Interfaces.RealInput intLat_wes
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,120},{240,160}})));
    Modelica.Blocks.Interfaces.RealInput intRad_hal
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,80},{240,120}})));
    Modelica.Blocks.Interfaces.RealInput intCon_hal
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,50},{240,90}})));
    Modelica.Blocks.Interfaces.RealInput intLat_hal
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,20},{240,60}})));
    Modelica.Blocks.Interfaces.RealInput intRad_eas
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,-20},{240,20}})));
    Modelica.Blocks.Interfaces.RealInput intCon_eas
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,-50},{240,-10}})));
    Modelica.Blocks.Interfaces.RealInput intLat_eas
    "Radiant, convective and latent heat input into room (positive if heat gain)"
      annotation (Placement(transformation(extent={{280,-80},{240,-40}})));
    RapidMPC.Modules.modExt exteas(
      lat=lat,
      A_ext=1.51,
      til=1.5707963267949,
      azi=-1.5707963267949)
      annotation (Placement(transformation(extent={{64,20},{84,40}})));
    RapidMPC.Modules.modZon eas(A_zon=13.7954)
      annotation (Placement(transformation(extent={{68,-10},{88,10}})));
    RapidMPC.Modules.modAdj adjeas(A_adj=10.22)
      annotation (Placement(transformation(extent={{34,-10},{54,10}})));
    RapidMPC.Modules.modZon hal(A_zon=9.09792)
      annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
    RapidMPC.Modules.modAdj adjwes(A_adj=10.22)
      annotation (Placement(transformation(extent={{-38,-10},{-18,10}})));
    RapidMPC.Modules.modZon wes(A_zon=13.7954)
      annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));
    RapidMPC.Modules.modExt extwes(
      lat=lat,
      A_ext=1.51,
      til=1.5707963267949,
      azi=1.5707963267949)
      annotation (Placement(transformation(extent={{-76,20},{-56,40}})));
    RapidMPC.Modules.modWin winwes(
      lat=lat,
      A_win=8.71,
      til=1.5707963267949,
      azi=1.5707963267949)
      annotation (Placement(transformation(extent={{-76,-40},{-56,-20}})));
    RapidMPC.Modules.modWin wineas(
      lat=lat,
      A_win=8.71,
      azi(displayUnit="deg") = -1.5707963267949,
      til=1.5707963267949)
      annotation (Placement(transformation(extent={{64,-40},{84,-20}})));
  protected
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Room air temperature sensor"
      annotation (Placement(transformation(extent={{-2,-64},{18,-44}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen1
    "Room air temperature sensor"
      annotation (Placement(transformation(extent={{24,-88},{44,-68}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen2
    "Room air temperature sensor"
      annotation (Placement(transformation(extent={{66,-106},{86,-86}})));
  public
  Modelica.Blocks.Interfaces.RealOutput easTdb
    annotation (Placement(transformation(extent={{240,-150},{260,-130}})));
  Modelica.Blocks.Interfaces.RealOutput halTdb
    annotation (Placement(transformation(extent={{240,-130},{260,-110}})));
  Modelica.Blocks.Interfaces.RealOutput wesTdb
    annotation (Placement(transformation(extent={{240,-110},{260,-90}})));
    Modelica.Blocks.Interfaces.RealInput weaTDryBul
    "Input dry bulb temperature"
    annotation (Placement(transformation(extent={{-280,180},{-240,220}})));
    Modelica.Blocks.Interfaces.RealInput weaHDirNor
    "Input infrared horizontal radiation"
    annotation (Placement(transformation(extent={{-280,140},{-240,180}})));
    Modelica.Blocks.Interfaces.RealInput weaHGloHor
    "Input direct normal radiation"
    annotation (Placement(transformation(extent={{-280,100},{-240,140}})));
    Modelica.Blocks.Interfaces.RealInput weaHDifHor
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,60},{-240,100}})));
    Modelica.Blocks.Interfaces.RealInput weaCloTim
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-20},{-240,20}})));
    Modelica.Blocks.Interfaces.RealInput weaSolTim
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,-70},{-240,-30}})));
    Modelica.Blocks.Interfaces.RealInput weaSolZen
    "Input global horizontal radiation" annotation (Placement(
        transformation(extent={{-280,20},{-240,60}})));
  RapidMPC.BoundaryConditions.Wea2Bus wea2Bus
      annotation (Placement(transformation(extent={{-164,138},{-120,242}})));
    Modelica.Blocks.Interfaces.RealInput conHeat_eas
    "HVAC Heating Input for eas Zone" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={40,-300})));
    Modelica.Blocks.Interfaces.RealInput conHeat_hal
    "HVAC Heating Input for hal Zone" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-300})));
    Modelica.Blocks.Interfaces.RealInput conHeat_wes
    "HVAC Heating Input for wes Zone" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-40,-300})));
    RapidMPC.Examples.HVAC.ConvectiveHeater convectiveHeater_wes(eff=0.99,
        q_max=1034.655)
      annotation (Placement(transformation(extent={{-60,-76},{-40,-56}})));
    RapidMPC.Examples.HVAC.ConvectiveHeater convectiveHeater_eas(eff=0.99,
        q_max=827.724)
      annotation (Placement(transformation(extent={{-60,-116},{-40,-96}})));
    Modelica.Blocks.Interfaces.RealOutput wesPhvac
      annotation (Placement(transformation(extent={{240,-170},{260,-150}})));
    Modelica.Blocks.Interfaces.RealOutput easPhvac
      annotation (Placement(transformation(extent={{240,-210},{260,-190}})));
    Modelica.Blocks.Math.Add3 add
    annotation (Placement(transformation(extent={{210,-250},{230,-230}})));
    Modelica.Blocks.Interfaces.RealOutput Popt
      annotation (Placement(transformation(extent={{240,-250},{260,-230}})));
    RapidMPC.Examples.HVAC.ConvectiveHeater convectiveHeater_hal(eff=0.99,
        q_max=350)
      annotation (Placement(transformation(extent={{-60,-96},{-40,-76}})));
  Modelica.Blocks.Interfaces.RealOutput halPhvac
    annotation (Placement(transformation(extent={{240,-190},{260,-170}})));
  Window.WindowModel windowModel(SampleFrequency=600, URNset=1)
    annotation (Placement(transformation(extent={{110,-212},{130,-192}})));
  Modelica.Blocks.Interfaces.RealInput Abs
    "Absence in the Previous (for arrival time) or Next (for Departure time) TimeStep"
    annotation (Placement(transformation(extent={{-280,-140},{-240,-100}})));
  Modelica.Blocks.Interfaces.RealInput EventRain "Event of Rain"
    annotation (Placement(transformation(extent={{-280,-180},{-240,-140}})));
  Modelica.Blocks.Interfaces.RealInput ToutDailyMean
    "Daily Mean Outdoor Air Temperature" annotation (Placement(
        transformation(extent={{-280,-220},{-240,-180}})));
  Modelica.Blocks.Math.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{-98,-238},{-78,-218}})));
  Modelica.Blocks.Sources.Constant const(k=273.15)
    annotation (Placement(transformation(extent={{-138,-258},{-118,-238}})));
  Modelica.Blocks.Math.Add add2(k2=-1)
    annotation (Placement(transformation(extent={{108,-174},{128,-154}})));
  equation

    // Fluid connections
    connect(extwes.porZon, wes.porZon) annotation (Line(points={{-55,30},{
          -46,30},{-46,5},{-55,5}},
                              color={191,0,0}));
    connect(wes.porZon, adjwes.porAdj) annotation (Line(points={{-55,5},{
          -42,5},{-42,0},{-39,0}},
                         color={191,0,0}));
    connect(adjwes.porZon, hal.porZon)
      annotation (Line(points={{-17,0},{19,0},{19,5}}, color={191,0,0}));
    connect(adjeas.porZon, eas.porZon)
      annotation (Line(points={{55,0},{89,0},{89,5}}, color={191,0,0}));
    connect(exteas.porZon, eas.porZon)
      annotation (Line(points={{85,30},{96,30},{96,5},{89,5}}, color={191,0,0}));

  connect(intRad_wes, wes.intRad) annotation (Line(points={{260,200},{260,
          200},{210,200},{210,174},{-44,174},{-44,62},{-88,62},{-88,-7},{
          -78,-7}}, color={0,0,127}));
  connect(intCon_wes, wes.intCon) annotation (Line(points={{260,170},{-40,
          170},{-40,58},{-84,58},{-84,7},{-78,7}}, color={0,0,127}));
  connect(intRad_hal, hal.intRad) annotation (Line(points={{260,100},{-12,
          100},{-12,-7},{-4,-7}}, color={0,0,127}));
  connect(intCon_hal, hal.intCon) annotation (Line(points={{260,70},{210,70},
          {210,104},{-8,104},{-8,7},{-4,7}}, color={0,0,127}));
  connect(intRad_eas, eas.intRad) annotation (Line(points={{260,0},{210,0},
          {210,28},{116,28},{116,16},{60,16},{60,-6},{66,-6},{66,-7}},
                                                               color={0,0,
          127}));
  connect(intCon_eas, eas.intCon) annotation (Line(points={{260,-30},{206,
          -30},{206,22},{120,22},{120,12},{62,12},{62,6},{66,6},{66,7}},
                                                                  color={0,
          0,127}));
    connect(hal.porZon, adjeas.porAdj)
      annotation (Line(points={{19,5},{19,0},{33,0}}, color={191,0,0}));
  connect(temSen.port, wes.porZon) annotation (Line(points={{-2,-54},{-2,-44},{-46,
            -44},{-46,5},{-55,5}},         color={191,0,0}));
  connect(temSen1.port, adjeas.porAdj)
    annotation (Line(points={{24,-78},{24,0},{33,0}}, color={191,0,0}));
  connect(temSen.T, wesTdb) annotation (Line(points={{18,-54},{18,-54},{96,-54},{96,
            -78},{216,-78},{216,-100},{250,-100}},           color={0,0,127}));
  connect(temSen1.T, halTdb) annotation (Line(points={{44,-78},{44,-80},{212,-80},
            {212,-120},{250,-120}},        color={0,0,127}));
  connect(eas.porZon, temSen2.port) annotation (Line(points={{89,5},{120,5},{120,-48},
            {54,-48},{54,-96},{66,-96}},         color={191,0,0}));
  connect(temSen2.T, easTdb) annotation (Line(points={{86,-96},{86,-96},{96,-96},{
            96,-82},{208,-82},{208,-140},{250,-140}},          color={0,0,
          127}));
  connect(winwes.porZon, wes.porZon) annotation (Line(points={{-55,-30},{
          -46,-30},{-46,5},{-55,5}}, color={191,0,0}));
  connect(wineas.porZon, eas.porZon) annotation (Line(points={{85,-30},{96,
          -30},{96,5},{89,5}}, color={191,0,0}));
  connect(weaTDryBul, wea2Bus.weaTDryBul) annotation (Line(points={{-260,
          200},{-234,200},{-234,228},{-166,228}}, color={0,0,127}));
  connect(weaHDirNor, wea2Bus.weaHDirNor) annotation (Line(points={{-260,
          160},{-218,160},{-218,180},{-166,180}}, color={0,0,127}));
  connect(weaHGloHor, wea2Bus.weaHGloHor) annotation (Line(points={{-260,
          120},{-216,120},{-216,174},{-166,174}}, color={0,0,127}));
  connect(weaHDifHor, wea2Bus.weaHDifHor) annotation (Line(points={{-260,80},
          {-214,80},{-214,168},{-166,168}},         color={0,0,127}));
  connect(weaSolZen, wea2Bus.weaSolZen) annotation (Line(points={{-260,40},
          {-208,40},{-208,149.8},{-166,149.8}},   color={0,0,127}));
  connect(weaCloTim, wea2Bus.weaCloTim) annotation (Line(points={{-260,0},{
          -206,0},{-206,144},{-166,144}},     color={0,0,127}));
  connect(weaSolTim, wea2Bus.weaSolTim) annotation (Line(points={{-260,-50},
          {-204,-50},{-204,138},{-166,138}},  color={0,0,127}));
  connect(wea2Bus.weaBus, extwes.weaBus) annotation (Line(
      points={{-120,190},{-114,190},{-110,190},{-110,30},{-77,30}},
      color={255,204,51},
      thickness=0.5));
  connect(wea2Bus.weaBus, winwes.weaBus) annotation (Line(
      points={{-120,190},{-110,190},{-110,-30},{-77,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(wea2Bus.weaBus, wineas.weaBus) annotation (Line(
      points={{-120,190},{-110,190},{-110,40},{28,40},{28,-30},{63,-30}},
      color={255,204,51},
      thickness=0.5));
  connect(wea2Bus.weaBus, exteas.weaBus) annotation (Line(
      points={{-120,190},{-110,190},{-110,40},{28,40},{28,30},{63,30}},
      color={255,204,51},
      thickness=0.5));
    connect(convectiveHeater_wes.HeatOutput, wes.porZon) annotation (Line(points={
            {-39.6,-66},{-24,-66},{-24,-16},{-46,-16},{-46,5},{-55,5}}, color={191,
            0,0}));
    connect(convectiveHeater_eas.HeatOutput, eas.porZon) annotation (Line(points={
            {-39.6,-106},{-24,-106},{-12,-106},{-12,-16},{46,-16},{96,-16},{96,5},
            {89,5}}, color={191,0,0}));
    connect(conHeat_wes, convectiveHeater_wes.u) annotation (Line(points={{-40,-300},
            {-40,-300},{-40,-180},{-40,-176},{-102,-176},{-102,-66},{-62,-66}},
          color={0,0,127}));
    connect(conHeat_eas, convectiveHeater_eas.u) annotation (Line(points={{40,-300},
            {40,-300},{40,-160},{40,-154},{-94,-154},{-94,-106},{-62,-106}},
          color={0,0,127}));
    connect(convectiveHeater_wes.P_e, wesPhvac) annotation (Line(points={{-39,-72},
            {-2,-72},{-2,-110},{110,-110},{110,-86},{184,-86},{184,-160},{250,-160}},
          color={0,0,127}));
    connect(convectiveHeater_eas.P_e, easPhvac) annotation (Line(points={{-39,-112},
            {-39,-112},{-10,-112},{-10,-118},{114,-118},{114,-90},{176,-90},{176,-200},
            {250,-200}}, color={0,0,127}));
  connect(add.y, Popt)
    annotation (Line(points={{231,-240},{250,-240}}, color={0,0,127}));
  connect(add.u1, wesPhvac) annotation (Line(points={{208,-232},{184,-232},
          {184,-160},{250,-160}}, color={0,0,127}));
  connect(conHeat_hal, convectiveHeater_hal.u) annotation (Line(points={{0,
          -300},{0,-300},{0,-166},{0,-164},{-98,-164},{-98,-86},{-62,-86}},
        color={0,0,127}));
  connect(convectiveHeater_hal.P_e, halPhvac) annotation (Line(points={{-39,
          -92},{-6,-92},{-6,-114},{112,-114},{112,-88},{180,-88},{180,-180},
          {250,-180}}, color={0,0,127}));
  connect(add.u2, halPhvac) annotation (Line(points={{208,-240},{180,-240},
          {180,-180},{250,-180}}, color={0,0,127}));
  connect(add.u3, easPhvac) annotation (Line(points={{208,-248},{176,-248},
          {176,-200},{250,-200}}, color={0,0,127}));
  connect(convectiveHeater_hal.HeatOutput, adjeas.porAdj) annotation (Line(
        points={{-39.6,-86},{-18,-86},{-18,-14},{24,-14},{24,0},{33,0}},
        color={191,0,0}));
  connect(windowModel.Abs, Abs) annotation (Line(points={{108,-202},{14,
          -202},{14,-200},{-182,-200},{-182,-120},{-260,-120}}, color={0,0,
          127}));
  connect(windowModel.EventRain, EventRain) annotation (Line(points={{108,
          -206},{-38,-206},{-38,-206},{-184,-206},{-184,-160},{-260,-160}},
        color={0,0,127}));
  connect(windowModel.ToutDailyMean, ToutDailyMean) annotation (Line(points={{108,
          -210},{94,-210},{94,-210},{-260,-210},{-260,-200}},      color={0,
          0,127}));
  connect(weaTDryBul, add1.u1) annotation (Line(points={{-260,200},{-180,
          200},{-180,-222},{-100,-222}}, color={0,0,127}));
  connect(const.y, add1.u2) annotation (Line(points={{-117,-248},{-117,-248},
          {-100,-248},{-100,-234}}, color={0,0,127}));
  connect(add1.y, windowModel.Tout) annotation (Line(points={{-77,-228},{2,
          -228},{68,-228},{68,-198},{108,-198}}, color={0,0,127}));
  connect(wesTdb, add2.u1) annotation (Line(points={{250,-100},{206,-100},{
          156,-100},{156,-136},{94,-136},{94,-158},{106,-158}}, color={0,0,
          127}));
  connect(const.y, add2.u2) annotation (Line(points={{-117,-248},{78,-248},
          {78,-170},{106,-170}}, color={0,0,127}));
  connect(add2.y, windowModel.Tin) annotation (Line(points={{129,-164},{140,
          -164},{140,-184},{96,-184},{96,-194},{108,-194}}, color={0,0,127}));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -280},{240,260}}),   graphics={
          Rectangle(
            extent={{-130,124},{138,-122}},
            lineColor={0,0,0},
            lineThickness=1,
            fillPattern=FillPattern.Solid,
            fillColor={255,255,255}),
          Text(
            extent={{64,-122},{136,-138}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
          textString="Reduced Order Model"),
          Text(
            extent={{-164,134},{-120,122}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            textString="Weather Input",
            fontSize=12),
          Rectangle(
            extent={{-118,132},{-102,114}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-50,132},{-34,114}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-32,136},{46,122}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
            textString="Internal Load West Input"),
          Rectangle(
            extent={{-8,9},{8,-9}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={138,103},
            rotation=90),
          Text(
            extent={{138,122},{216,108}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
            textString="Internal Load Hall Input"),
          Text(
            extent={{138,44},{216,30}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
            textString="Internal Load East Input"),
          Rectangle(
            extent={{-8,9},{8,-9}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={138,25},
            rotation=90),
          Rectangle(
            extent={{-11.5,9.5},{11.5,-9.5}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={137.5,-84.5},
            rotation=90),
          Text(
            extent={{138,-62},{216,-76}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
          textString="Measurement Outputs"),
          Rectangle(
            extent={{-8,9},{8,-9}},
            lineColor={255,255,255},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            origin={-98,-123},
            rotation=180),
          Text(
            extent={{-96,-124},{-20,-136}},
            lineColor={0,0,0},
            lineThickness=1,
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            fontSize=12,
            textString="Control Signals")}),
                                  Icon(coordinateSystem(preserveAspectRatio=false,
            extent={{-240,-280},{240,260}}),
                                       graphics={
        Rectangle(
          extent={{-240,260},{240,-280}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-80,-30},{80,26}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-74,18},{-24,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{-80,16},{-74,-18}},
            lineColor={95,95,95},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-78,16},{-76,-18}},
            lineColor={95,95,95},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{24,18},{74,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{-16,18},{16,-20}},
            pattern=LinePattern.None,
            lineColor={117,148,176},
            fillColor={170,213,255},
            fillPattern=FillPattern.Sphere),
          Rectangle(
            extent={{74,16},{80,-18}},
            lineColor={95,95,95},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{76,16},{78,-18}},
            lineColor={95,95,95},
            fillColor={170,213,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{20,100},{96,68}},
            lineColor={0,0,127},
            textString="TRoo"),
          Text(
            extent={{20,74},{96,42}},
            lineColor={0,0,127},
            textString="Xi"),
          Text(
            extent={{22,-44},{98,-76}},
            lineColor={0,0,127},
            textString="HDirWin")}));
  end MPC_wAdapativeWindow;

  model RunMPC_wAdapativeWindow
    // Frankfurt, Germany
    parameter Modelica.SIunits.Angle lon= 8.6821*Modelica.Constants.pi/180;
    parameter Modelica.SIunits.Angle lat= 50.1109*Modelica.Constants.pi/180;
    parameter Modelica.SIunits.Time timZon= 1*3600;
    parameter Modelica.SIunits.Time modTimOffset = 0;

  MPC_wAdapativeWindow
      mpc(
    timZon=timZon,
    modTimOffset=0,
    lon=lon,
    lat=lat)
    annotation (Placement(transformation(extent={{-108,-102},{146,138}})));
    Modelica.Blocks.Sources.CombiTimeTable intGaiFra(
         extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,
        0.05; 3600*8,0.05; 3600*8,0.9; 3600*12,0.9; 3600*12,0.8; 3600*13,
        0.8; 3600*13,1; 3600*17,1; 3600*17,0.1; 3600*20,0.1; 3600*20,0.05;
        3600*24,0.05])
    "Fraction of internal heat gain"
      annotation (Placement(transformation(extent={{-544,200},{-524,220}})));
    Modelica.Blocks.Math.MatrixGain gai(K=20*[0.4; 0.4; 0.2])
    "Matrix gain to split up heat gain in radiant, convective and latent gain"
      annotation (Placement(transformation(extent={{-280,200},{-260,220}})));
  Modelica.Blocks.Routing.DeMultiplex3 deMultiplex3_1
    annotation (Placement(transformation(extent={{226,116},{206,136}})));
    Modelica.Blocks.Sources.CombiTimeTable intGaiFra1(
         extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic, table=[0,
        0.05; 3600*7,0.05; 3600*7,0.1; 3600*19,0.1; 3600*19,0.05; 3600*24,
        0.05]) "Fraction of internal heat gain"
      annotation (Placement(transformation(extent={{-544,160},{-524,180}})));
    Modelica.Blocks.Math.MatrixGain gai1(
                                        K=20*[0.4; 0.4; 0.2])
    "Matrix gain to split up heat gain in radiant, convective and latent gain"
      annotation (Placement(transformation(extent={{-280,160},{-260,180}})));
  Modelica.Blocks.Routing.DeMultiplex3 deMultiplex3_2
    annotation (Placement(transformation(extent={{226,50},{206,70}})));
  RapidMPC.BoundaryConditions.WeatherCalculator2 weaDat(
      use_TDryBul=true,
      HSou=Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor,

      lon=lon,
      lat=lat,
      timZon=timZon,
      modTimOffset=0)
      annotation (Placement(transformation(extent={{-408,-28},{-268,114}})));
  RapidMPC.Examples.Controllers.DualSetpoint DualSetpoint(
      Setback=5,
      OnStatus=true,
      Setpoint=22 + 273)
      annotation (Placement(transformation(extent={{-116,-174},{-96,-154}})));
    Modelica.Blocks.Sources.CombiTimeTable FrankfurtWeather(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=true,
    table=fill(
              0.0,
              0,
              2),
    tableName="Weatherfile",
    fileName="weatherfile.txt",
    columns=2:7,
    timeScale(displayUnit="h") = 3600)
                                "Fraction of internal heat gain"
    annotation (Placement(transformation(extent={{-544,104},{-524,124}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-462,74},{-442,94}})));
  Modelica.Blocks.Sources.Constant const(k=273.15)
    annotation (Placement(transformation(extent={{-500,40},{-480,60}})));
    Modelica.Blocks.Sources.CombiTimeTable EventRain(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=true,
    table=fill(
              0.0,
              0,
              2),
    tableName="EventRain",
    fileName="EventRain.txt",
    timeScale(displayUnit="h") = 3600)
    annotation (Placement(transformation(extent={{-544,-88},{-524,-68}})));
    Modelica.Blocks.Sources.CombiTimeTable ToutMean(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableOnFile=true,
    table=fill(
              0.0,
              0,
              2),
    timeScale(displayUnit="h") = 3600,
    tableName="dmTAir",
    fileName="dmTAir.txt")
    annotation (Placement(transformation(extent={{-544,-116},{-524,-96}})));
    Modelica.Blocks.Sources.CombiTimeTable Occupancy(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    tableName="EventRain",
    fileName="EventRain.txt",
    timeScale(displayUnit="h") = 3600,
    tableOnFile=false,
    table=[0.0,0.0; 8,0; 8,1; 18,1; 18,0; 24,0])
    annotation (Placement(transformation(extent={{-544,-52},{-524,-32}})));
  equation

  connect(intGaiFra.y, gai.u)
    annotation (Line(points={{-523,210},{-306,210},{-282,210}},
                                                     color={0,0,127}));
  connect(intGaiFra1.y, gai1.u) annotation (Line(points={{-523,170},{-523,
          170},{-282,170}}, color={0,0,127}));
  connect(gai.y, deMultiplex3_1.u) annotation (Line(points={{-259,210},{-34,
          210},{242,210},{242,142},{242,126},{228,126}}, color={0,0,127}));
  connect(gai1.y, deMultiplex3_2.u) annotation (Line(points={{-259,170},{
          -259,170},{250,170},{250,60},{228,60}}, color={0,0,127}));
  connect(weaDat.HDirNor, mpc.weaHDirNor) annotation (Line(points={{
          -265.667,93.7143},{-194.85,93.7143},{-194.85,93.5556},{-118.583,
          93.5556}},
        color={0,0,127}));
  connect(weaDat.HGloHor, mpc.weaHGloHor) annotation (Line(points={{
          -265.667,83.5714},{-196.85,83.5714},{-196.85,75.7778},{-118.583,
          75.7778}},
        color={0,0,127}));
  connect(weaDat.HDifHor, mpc.weaHDifHor) annotation (Line(points={{
          -265.667,103.857},{-178,103.857},{-178,58},{-118.583,58}},  color=
         {0,0,127}));
  connect(weaDat.solZen, mpc.weaSolZen) annotation (Line(points={{-265.667,
          49.7619},{-190.85,49.7619},{-190.85,40.2222},{-118.583,40.2222}},
        color={0,0,127}));
  connect(weaDat.cloTim, mpc.weaCloTim) annotation (Line(points={{-265.667,
          39.619},{-193.85,39.619},{-193.85,22.4444},{-118.583,22.4444}},
        color={0,0,127}));
  connect(weaDat.solTim1, mpc.weaSolTim) annotation (Line(points={{-265.667,
          29.4762},{-194.85,29.4762},{-194.85,0.222222},{-118.583,0.222222}},
        color={0,0,127}));
  connect(mpc.wesTdb, DualSetpoint.meaTDryBul_wes) annotation (Line(points={{151.292,
          -22},{204,-22},{204,-204},{-154,-204},{-154,-158},{-118,-158}},
                                          color={0,0,127}));
  connect(mpc.halTdb, DualSetpoint.meaTDryBul_hal) annotation (Line(points={{151.292,
          -30.8889},{202,-30.8889},{202,-202},{-152,-202},{-152,-164},{-118,
          -164}},                                     color={0,0,127}));
  connect(mpc.easTdb, DualSetpoint.meaTDryBul_eas) annotation (Line(points={{151.292,
          -39.7778},{176,-39.7778},{176,-40},{200,-40},{200,-200},{-150,
          -200},{-150,-170},{-118,-170}},
                              color={0,0,127}));
  connect(DualSetpoint.y_wes, mpc.conHeat_wes) annotation (Line(points={{-95,
          -160},{-2.16667,-160},{-2.16667,-110.889}},     color={0,0,127}));
  connect(DualSetpoint.y_hal, mpc.conHeat_hal) annotation (Line(points={{-95,
          -164},{19,-164},{19,-110.889}},     color={0,0,127}));
  connect(DualSetpoint.y_eas, mpc.conHeat_eas) annotation (Line(points={{-95,
          -168},{40.1667,-168},{40.1667,-110.889}},     color={0,0,127}));
  connect(const.y, add.u2) annotation (Line(points={{-479,50},{-479,50},{
          -474,50},{-474,78},{-464,78}},                     color={0,0,127}));
  connect(add.y, weaDat.TDryBul_in) annotation (Line(points={{-441,84},{
          -432,84},{-432,83.5714},{-412.667,83.5714}},
                                                     color={0,0,127}));
  connect(Occupancy.y[1], mpc.Abs) annotation (Line(points={{-523,-42},{
          -118.583,-42},{-118.583,-30.8889}}, color={0,0,127}));
  connect(EventRain.y[1], mpc.EventRain) annotation (Line(points={{-523,-78},
          {-292,-78},{-292,-58},{-118.583,-58},{-118.583,-48.6667}}, color=
          {0,0,127}));
  connect(ToutMean.y[1], mpc.ToutDailyMean) annotation (Line(points={{-523,
          -106},{-388,-106},{-262,-106},{-262,-66.4444},{-118.583,-66.4444}},
        color={0,0,127}));
  connect(FrankfurtWeather.y[1], add.u1) annotation (Line(points={{-523,114},
          {-523,114},{-474,114},{-474,90},{-464,90}}, color={0,0,127}));
  connect(FrankfurtWeather.y[5], weaDat.HDirNor_in) annotation (Line(points={{-523,
          114},{-512,114},{-512,2.42857},{-412.667,2.42857}},       color={
          0,0,127}));
  connect(FrankfurtWeather.y[6], weaDat.HDifHor_in) annotation (Line(points={{-523,
          114},{-512,114},{-512,-17.8571},{-412.667,-17.8571}},       color=
         {0,0,127}));
  connect(deMultiplex3_1.y1[1], mpc.intRad_wes) annotation (Line(points={{205,133},
          {184,133},{184,111.333},{156.583,111.333}},          color={0,0,
          127}));
  connect(deMultiplex3_1.y2[1], mpc.intCon_wes) annotation (Line(points={{205,126},
          {196,126},{190,126},{190,98},{156.583,98}},          color={0,0,
          127}));
  connect(deMultiplex3_1.y3[1], mpc.intLat_wes) annotation (Line(points={{205,119},
          {196,119},{196,84.6667},{156.583,84.6667}},          color={0,0,
          127}));
  connect(deMultiplex3_2.y1[1], mpc.intRad_hal) annotation (Line(points={{205,67},
          {176.5,67},{176.5,66.8889},{156.583,66.8889}},         color={0,0,
          127}));
  connect(deMultiplex3_2.y2[1], mpc.intCon_hal) annotation (Line(points={{205,60},
          {176,60},{176,53.5556},{156.583,53.5556}},         color={0,0,127}));
  connect(deMultiplex3_2.y3[1], mpc.intLat_hal) annotation (Line(points={{205,53},
          {178.5,53},{178.5,40.2222},{156.583,40.2222}},         color={0,0,
          127}));
  connect(mpc.intRad_eas, mpc.intRad_wes) annotation (Line(points={{156.583,
          22.4444},{184,22.4444},{184,111.333},{156.583,111.333}}, color={0,
          0,127}));
  connect(mpc.intCon_eas, mpc.intCon_wes) annotation (Line(points={{156.583,
          9.11111},{190,9.11111},{190,98},{156.583,98}}, color={0,0,127}));
  connect(mpc.intLat_eas, mpc.intLat_wes) annotation (Line(points={{156.583,
          -4.22222},{196,-4.22222},{196,84.6667},{156.583,84.6667}}, color=
          {0,0,127}));
  connect(add.y, mpc.weaTDryBul) annotation (Line(points={{-441,84},{-432,
          84},{-432,86},{-432,136},{-232,136},{-168,136},{-168,111.333},{
          -118.583,111.333}}, color={0,0,127}));
    annotation (Diagram(coordinateSystem(extent={{-600,-240},{280,240}})), Icon(
          coordinateSystem(extent={{-600,-240},{280,240}})),
    experiment(
      StartTime=2.592e+06,
      StopTime=3.8016e+06,
      Interval=60),
    __Dymola_experimentSetupOutput);
  end RunMPC_wAdapativeWindow;
  annotation (uses(Modelica(version="3.2.2"), Buildings(version="3.0.1")));
end LBNL71T_MPC;