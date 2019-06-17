with UxAS.Common.Utilities.Unit_Conversions; use UxAS.Common.Utilities.Unit_Conversions;
with Ada.Numerics.Long_Elementary_Functions; use  Ada.Numerics.Long_Elementary_Functions;


package body UxAS.Common.Utilities.Unit_Conversions with SPARK_Mode => On is

   procedure Initialize (Latitude_Init_RAD  : in RAD_Latitude;
                         Longitude_Init_RAD : in RAD_Angle)
   is
   begin
      if not B_Initilized then

         --  m_dLatitudeInitial_rad  = dLatitudeInit_rad;
         --  m_dLongitudeInitial_rad = dLongitudeInit_rad;
         Latitude_Initial_RAD  := Latitude_Init_RAD;
         Longitude_Initial_RAD := Longitude_Init_RAD;

         declare
            --  double dDenominatorMeridional = std::pow((1.0 - (m_dEccentricitySquared * std::pow(std::sin(dLatitudeInit_rad), 2.0))), (3.0 / 2.0));
            --  double dDenominatorTransverse = pow((1.0 - (m_dEccentricitySquared * std::pow(std::sin(dLatitudeInit_rad), 2.0))), 0.5);

            Sin_Sqrt_Latitude : constant Long_Float := Sin (Latitude_Init_RAD) * Sin (Latitude_Init_RAD);

            Temp : constant Long_Float := 1.0 - (Eccentricity_Squared * Sin_Sqrt_Latitude);
            pragma Assume (0.98 < Temp and Temp <= 1.0);

            Denominator_Meridional : constant Long_Float := Temp**(3.0 / 2.0); -- 0.3535533905932738 <= Denominator_Meridional <= 1.0
            Denominator_Transverse : constant Long_Float := Temp**(0.5);       -- 0.7071067811865475 <= Denominator_Transverse <= 1.0
            pragma Assume (0.8  <= Denominator_Meridional and Denominator_Meridional <= 1.0);
            pragma Assume (0.95 <= Denominator_Transverse and Denominator_Transverse <= 1.0);

            Temp2 : constant Long_Float := Radius_Equatorial_M * (1.0 - Eccentricity_Squared);
            pragma Assert (6300000.0 < Temp2 and Temp2 < 6350000.0);

         begin
            --  assert(dDenominatorMeridional > 0.0);
            --  assert(dDenominatorTransverse > 0.0);

            --  m_dRadiusMeridional_m = (dDenominatorMeridional <= 0.0) ? (0.0) : (m_dRadiusEquatorial_m * (1.0 - m_dEccentricitySquared) / dDenominatorMeridional);

            pragma Assume (6300000.0 < Temp2 / Denominator_Meridional and Temp2 / Denominator_Meridional < 8000000.0);
            Radius_Meridional_M := Temp2 / Denominator_Meridional;

            --  m_dRadiusTransverse_m = (dDenominatorTransverse <= 0.0) ? (0.0) : (m_dRadiusEquatorial_m / dDenominatorTransverse);

             pragma Assume (6300000.0 < Radius_Equatorial_M / Denominator_Transverse and Radius_Equatorial_M / Denominator_Transverse < 6700000.0);
            Radius_Transverse_M := Radius_Equatorial_M / Denominator_Transverse;

             pragma Assume (0.0 <= (Radius_Transverse_M * Cos (Latitude_Init_RAD)) and (Radius_Transverse_M * Cos (Latitude_Init_RAD)) < 6700000.0);
            --  m_dRadiusSmallCircleLatitude_m = m_dRadiusTransverse_m * cos(dLatitudeInit_rad);
            -- minimized to 0.001 for overflow issue
            if (Radius_Transverse_M * Cos (Latitude_Init_RAD)) < 0.001 then
               Radius_Small_Circle_Latitude_M := 0.001;
            else
               Radius_Small_Circle_Latitude_M := (Radius_Transverse_M * Cos (Latitude_Init_RAD));
            end if;


            B_Initilized := True;
         end;

      end if;
   end Initialize;

   procedure Re_Initialize (Latitude_Init_RAD  : in RAD_Latitude;
                            Longitude_Init_RAD : in RAD_Angle)
   is null;
   --  begin

   --  //    m_bInitialized = false;
   --  //    Initialize(dLatitudeInit_rad,dLongitudeInit_rad);
   --  //#error "ERROR: CUnitConversions::ReInitialize::   reiitialize is no longer allowed!!!"

   --        B_Initilized := False;
   --        Initialize(Latitude_Init_RAD => Latitude_Init_RAD,
   --                        Longitude_Init_RAD =>Longitude_Init_RAD);
   --  end Re_Initialize;

   --  ////////////////////////////////////////////////////////////////////////////
   --  ///////    FROM LAT/LONG TO NORTH/EAST

   procedure Convert_Lat_Long_RAD_To_North_East_M
     (Latitude_RAD  : in RAD_Latitude;
      Longitude_RAD : in RAD_Angle;
      North_M      : out Earth_Coordonate_M;
      East_M       : out Earth_Coordonate_M)
   is
   begin

      --    if (!m_bInitialized){Initialize(dLatitude_rad, dLongitude_rad);  }
      if not B_Initilized then
         Initialize (Latitude_RAD,Longitude_RAD);
      end if;


      --  dNorth_m = m_dRadiusMeridional_m * (dLatitude_rad - m_dLatitudeInitial_rad);
      --  dEast_m = m_dRadiusSmallCircleLatitude_m * (dLongitude_rad - m_dLongitudeInitial_rad);
      -- add Normalize for be sure it will not return inversed result
      North_M := Radius_Meridional_M * Normalize_Angle_RAD (RAD_Angle (Latitude_RAD) - RAD_Angle (Latitude_Initial_RAD));
      East_M  := Radius_Small_Circle_Latitude_M * Normalize_Angle_RAD (Longitude_RAD - Longitude_Initial_RAD);

   end Convert_Lat_Long_RAD_To_North_East_M;

   procedure Convert_Lat_Long_RAD_To_North_East_FT
     (Latitude_RAD  : in RAD_Latitude;
      Longitude_RAD : in RAD_Angle;
      North_FT     : out Earth_Coordonate_FT;
      East_FT      : out Earth_Coordonate_FT)
   is
      North_M : Earth_Coordonate_M;
      East_M  : Earth_Coordonate_M;
   begin

      Convert_Lat_Long_RAD_To_North_East_M (Latitude_RAD  => Latitude_RAD,
                                            Longitude_RAD => Longitude_RAD,
                                            North_M       => North_M,
                                            East_M        => East_M);

      North_FT := To_FT_Coordonate (North_M);
      East_FT  := To_FT_Coordonate (East_M );

   end Convert_Lat_Long_RAD_To_North_East_FT;

   procedure Convert_Lat_Long_DEG_To_North_East_M
     (
      Latitude_DEG  : in DEG_Latitude;
      Longitude_DEG : in DEG_Angle;
      North_M      : out Earth_Coordonate_M;
      East_M       : out Earth_Coordonate_M)
   is
      --  double dLatitude_rad = dLatitude_deg * n_Const::c_Convert::dDegreesToRadians();
      --  double dLongitude_rad = dLongitude_deg * n_Const::c_Convert::dDegreesToRadians();

      Latitude_RAD  : constant RAD_Latitude := To_Radians (Latitude_DEG);
      Longitude_RAD : constant RAD_Angle := To_Radians (Longitude_DEG);
   begin
      Convert_Lat_Long_RAD_To_North_East_M (Latitude_RAD  => Latitude_RAD,
                                            Longitude_RAD => Longitude_RAD,
                                            North_M       => North_M,
                                            East_M        => East_M);

   end Convert_Lat_Long_DEG_To_North_East_M;

   procedure Convert_Lat_Long_DEG_To_North_East_FT
     (Latitude_DEG  : in DEG_Latitude;
      Longitude_DEG : in DEG_Angle;
      North_FT     : out Earth_Coordonate_FT;
      East_FT      : out Earth_Coordonate_FT)
   is
      --  double dLatitude_rad = dLatitude_deg * n_Const::c_Convert::dDegreesToRadians();
      --  double dLongitude_rad = dLongitude_deg * n_Const::c_Convert::dDegreesToRadians();
      Latitude_RAD  : constant RAD_Latitude := To_Radians (Latitude_DEG );
      Longitude_RAD : constant RAD_Angle := To_Radians (Longitude_DEG);

      North_M : Earth_Coordonate_M;
      East_M  : Earth_Coordonate_M;
   begin
      Convert_Lat_Long_RAD_To_North_East_M (Latitude_RAD  => Latitude_RAD,
                                            Longitude_RAD => Longitude_RAD,
                                            North_M       => North_M,
                                            East_M        => East_M);

      North_FT := To_FT_Coordonate (North_M);
      East_FT  := To_FT_Coordonate (East_M );

   end Convert_Lat_Long_DEG_To_North_East_FT;

   --  ////////////////////////////////////////////////////////////////////////////
   --  ///////     FROM NORTH/EAST TO LAT/LONG

   procedure Convert_North_East_M_To_Lat_Long_RAD
     (North_M       : in  Earth_Coordonate_M;
      East_M        : in  Earth_Coordonate_M;
      Latitude_RAD  : out RAD_Latitude;
      Longitude_RAD : out RAD_Angle)
   is
      Latitude_Angle : constant RAD_Angle := Normalize_Angle_RAD ((North_M / Radius_Meridional_M) + Latitude_Initial_RAD);

   begin
      -- for being sure that the latitude is in the rigth borne
      if Latitude_Angle > Pi_O2 then
         Latitude_RAD  := Pi - Latitude_Angle;
      elsif Latitude_Angle < - Pi_O2 then
         Latitude_RAD := - Pi - Latitude_Angle;
      else
         Latitude_RAD := Latitude_Angle;
      end if;
      Longitude_RAD := Normalize_Angle_RAD ((East_M / Radius_Small_Circle_Latitude_M) + Longitude_Initial_RAD);
   end Convert_North_East_M_To_Lat_Long_RAD;

   procedure Convert_North_East_M_To_Lat_Long_DEG
     (North_M       : in  Earth_Coordonate_M;
      East_M        : in  Earth_Coordonate_M;
      Latitude_DEG  : out DEG_Latitude;
      Longitude_DEG : out DEG_Angle)
   is
      Latitude_RAD  : RAD_Latitude;
      Longitude_RAD : RAD_Angle;
   begin

      Convert_North_East_M_To_Lat_Long_RAD (North_M, East_M,
                                            Latitude_RAD, Longitude_RAD);

      Latitude_DEG  := Latitude_To_Degrees (Latitude_RAD);
      Longitude_DEG := To_Degrees (Longitude_RAD);
   end  Convert_North_East_M_To_Lat_Long_DEG;

   procedure Convert_North_East_FT_To_Lat_Long_RAD
     (North_FT      : in Earth_Coordonate_FT;
      East_FT       : in Earth_Coordonate_FT;
      Latitude_RAD  : out RAD_Latitude;
      Longitude_RAD : out RAD_Angle)
   is
      North_M : constant Earth_Coordonate_M := North_FT * Feet_To_Meters;
      East_M  : constant Earth_Coordonate_M := East_FT  * Feet_To_Meters;
   begin

      Convert_North_East_M_To_Lat_Long_RAD (North_M, East_M,
                                            Latitude_RAD, Longitude_RAD);
   end Convert_North_East_FT_To_Lat_Long_RAD;

   procedure Convert_North_East_FT_To_Lat_Long_DEG
     (North_FT      : in  Earth_Coordonate_FT;
      East_FT       : in  Earth_Coordonate_FT;
      Latitude_DEG  : out DEG_Latitude;
      Longitude_DEG : out DEG_Angle)
   is
      North_M : constant Earth_Coordonate_M := North_FT * Feet_To_Meters;
      East_M  : constant Earth_Coordonate_M := East_FT  * Feet_To_Meters;
      Latitude_RAD  : RAD_Latitude;
      Longitude_RAD : RAD_Angle;
   begin

      Convert_North_East_M_To_Lat_Long_RAD (North_M, East_M,
                                            Latitude_RAD, Longitude_RAD);

      Latitude_DEG  := Latitude_To_Degrees (Latitude_RAD);
      Longitude_DEG := To_Degrees (Longitude_RAD);
   end Convert_North_East_FT_To_Lat_Long_DEG;

   --  ////////////////////////////////////////////////////////////////////////////
   --  ///////     LINEAR DISTANCES

   procedure Get_Linear_Distance_M_Lat1_Long1_RAD_To_Lat2_Long2_RAD
     (Latitude_1_RAD    : in  RAD_Latitude;
      Longitude_1_RAD   : in  RAD_Angle;
      Latitude_2_RAD    : in  RAD_Latitude;
      Longitude_2_RAD   : in  RAD_Angle;
      Linear_Distance_M : out Long_Float)
   is
      North_1_M : Earth_Coordonate_M;
      East_1_M  : Earth_Coordonate_M;
      North_2_M : Earth_Coordonate_M;
      East_2_M  : Earth_Coordonate_M;

   begin
      --  ConvertLatLong_radToNorthEast_m(dLatitude1_rad, dLongitude1_rad, dNorth1_m, dEast1_m);
      Convert_Lat_Long_RAD_To_North_East_M (Latitude_1_RAD,
                                            Longitude_1_RAD,
                                            North_1_M,
                                            East_1_M);

      --  ConvertLatLong_radToNorthEast_m(dLatitude2_rad, dLongitude2_rad, dNorth2_m, dEast2_m);
      Convert_Lat_Long_RAD_To_North_East_M (Latitude_2_RAD,
                                            Longitude_2_RAD,
                                            North_2_M,
                                            East_2_M);

      --  double dReturn = std::pow((std::pow((dNorth2_m - dNorth1_m), 2.0) + std::pow((dEast2_m - dEast1_m), 2.0)), 0.5);
      pragma Assert ((((Earth_Coordonate_M'Last*2.0)**2)*2.0) < Long_Float'Last);
      Linear_Distance_M := (Long_Float'((North_2_M - North_1_M) ** 2) + ((East_2_M * East_1_M) **2))**0.5;

   end Get_Linear_Distance_M_Lat1_Long1_RAD_To_Lat2_Long2_RAD;

   procedure Get_Linear_Distance_M_Lat1_Long1_DEG_To_Lat2_Long2_DEG
     (Latitude_1_DEG    : in  DEG_Latitude;
      Longitude_1_DEG   : in  DEG_Angle;
      Latitude_2_DEG    : in  DEG_Latitude;
      Longitude_2_DEG   : in  DEG_Angle;
      Linear_Distance_M : out Long_Float)
   is
      Latitude_1_RAD  : constant RAD_Latitude := To_Radians (Latitude_1_DEG );
      Longitude_1_RAD : constant RAD_Angle    := To_Radians (Longitude_1_DEG);
      Latitude_2_RAD  : constant RAD_Latitude := To_Radians (Latitude_2_DEG );
      Longitude_2_RAD : constant RAD_Angle    := To_Radians (Longitude_2_DEG);
   begin

      Get_Linear_Distance_M_Lat1_Long1_RAD_To_Lat2_Long2_RAD (Latitude_1_RAD    => Latitude_1_RAD,
                                                              Longitude_1_RAD   => Longitude_1_RAD,
                                                              Latitude_2_RAD    => Latitude_2_RAD,
                                                              Longitude_2_RAD   => Longitude_2_RAD,
                                                              Linear_Distance_M => Linear_Distance_M);
   end Get_Linear_Distance_M_Lat1_Long1_DEG_To_Lat2_Long2_DEG;

end Uxas.Common.Utilities.Unit_Conversions;
