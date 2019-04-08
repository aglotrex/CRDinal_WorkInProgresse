with UxAS.Common.Utilities.Unit_Conversions; use UxAS.Common.Utilities.Unit_Conversions;
--  with ADA.Numerics.Elementary_Functions;  use ADA.Numerics.Elementary_Functions;
with Ada.Numerics.Long_Elementary_Functions; use  Ada.Numerics.Long_Elementary_Functions;

package body Uxas.Common.Utilities.Unit_Conversions with SPARK_Mode => Off is
   
   
   
   procedure Initialize(Latitude_Init_RAD  : in Long_float;
                        Longitude_Init_RAD : in Long_float)
   is 
   begin
      if B_Initilized then
         
         -- m_dLatitudeInitial_rad  = dLatitudeInit_rad;
         -- m_dLongitudeInitial_rad = dLongitudeInit_rad;
         Latitude_Initial_RAD  := Latitude_Init_RAD;
         Longitude_Initial_RAD := Longitude_Init_RAD;
        
         
         declare
            -- double dDenominatorMeridional = std::pow((1.0 - (m_dEccentricitySquared * std::pow(std::sin(dLatitudeInit_rad), 2.0))), (3.0 / 2.0));
            -- double dDenominatorTransverse = pow((1.0 - (m_dEccentricitySquared * std::pow(std::sin(dLatitudeInit_rad), 2.0))), 0.5);
            Denominator_Meridional : constant Long_float := (1.0 -(Eccentricity_Squared 
                                                             * (Sin(Latitude_Init_RAD)**Long_Float(2.0))))**(3.0/2.0);
            Denominator_Transverse :constant  Long_float := (1.0 -(Eccentricity_Squared 
                                                             * (Sin(Latitude_Init_RAD)**2.0)))**(0.5);
          
         begin
            -- assert(dDenominatorMeridional > 0.0);
            -- assert(dDenominatorTransverse > 0.0);
            pragma Assert(Denominator_Meridional > 0.0);
            pragma Assert(Denominator_Transverse > 0.0);
            
            
            -- Long_float dDenominatorTransverse = pow((1.0 - (m_dEccentricitySquared * std::pow(std::sin(dLatitudeInit_rad), 2.0))), 0.5);
            Radius_Meridional_M := (if Denominator_Meridional <= 0.0 
                                    then 0.0 
                                    else Radius_Equatorial_M * ( 1.0 - Eccentricity_Squared) / Denominator_Meridional);
            
            --  m_dRadiusTransverse_m = (dDenominatorTransverse <= 0.0) ? (0.0) : (m_dRadiusEquatorial_m / dDenominatorTransverse);
            Radius_Transverse_M := (if Denominator_Transverse <= 0.0 
                                    then 0.0 
                                    else Radius_Equatorial_M / Denominator_Transverse);
            
            --  m_dRadiusSmallCircleLatitude_m = m_dRadiusTransverse_m * cos(dLatitudeInit_rad);
            Radius_Small_Circle_Latitude_M := (Radius_Transverse_M 
                                               * Cos(X => Latitude_Init_RAD));
            
            
            B_Initilized := True; 
         end;
         
      end if;
   end Initialize;
   
   
   procedure Re_Initialize(Latitude_Init_RAD  : in Long_float;
                           Longitude_Init_RAD : in Long_float)
   is null;
   --  begin
      
   --  //    m_bInitialized = false;
   --  //    Initialize(dLatitudeInit_rad,dLongitudeInit_rad);
   --  //#error "ERROR: CUnitConversions::ReInitialize::   reiitialize is no longer allowed!!!" 
      
   --        B_Initilized := False;
   --        Initialize(Latitude_Init_RAD => Latitude_Init_RAD,
   --                        Longitude_Init_RAD =>Longitude_Init_RAD);
   --  end Re_Initialize;
            
        
      
   -- ////////////////////////////////////////////////////////////////////////////
   -- ///////    FROM LAT/LONG TO NORTH/EAST
 
   
   
   procedure Convert_Lat_Long_RAD_To_North_East_M
     (Latitude_RAD  : in Long_float;
      Longitude_RAD : in Long_float;
      North_M      : out Long_float;
      East_M       : out Long_float)
   is
   begin
      
      --    if (!m_bInitialized){Initialize(dLatitude_rad, dLongitude_rad);  }
      if not B_Initilized then
         Initialize(Latitude_RAD,Longitude_RAD);
      end if;
      
      -- dNorth_m = m_dRadiusMeridional_m * (dLatitude_rad - m_dLatitudeInitial_rad);
      -- dEast_m = m_dRadiusSmallCircleLatitude_m * (dLongitude_rad - m_dLongitudeInitial_rad);
      North_M := Radius_Meridional_M * (Latitude_RAD - Latitude_Initial_RAD);
      East_M  := Radius_Small_Circle_Latitude_M * (Longitude_RAD - Longitude_Initial_RAD);
   end Convert_Lat_Long_RAD_To_North_East_M;
   
   procedure Convert_Lat_Long_RAD_To_North_East_FT
     (Latitude_RAD  : in Long_float;
      Longitude_RAD : in Long_float;
      North_FT     : out Long_float;
      East_FT      : out Long_float)
   is 
      North_M : Long_float; 
      East_M  : Long_float;
   begin
      
      --  if (!m_bInitialized){Initialize(dLatitude_rad, dLongitude_rad);  }
      if not B_Initilized then
         Initialize(Latitude_RAD,Longitude_RAD);
      end if;
         
      -- double dNorth_m = m_dRadiusMeridional_m * (dLatitude_rad - m_dLatitudeInitial_rad);
      -- double dEast_m = m_dRadiusSmallCircleLatitude_m * (dLongitude_rad - m_dLongitudeInitial_rad);
      Convert_Lat_Long_RAD_To_North_East_M(Latitude_RAD, Longitude_RAD ,
                                           North_M , East_M);
      
      -- dNorth_m = m_dRadiusMeridional_m * (dLatitude_rad - m_dLatitudeInitial_rad);
      -- dEast_m = m_dRadiusSmallCircleLatitude_m * (dLongitude_rad - m_dLongitudeInitial_rad);
      North_FT := North_M * Meter_to_Feet;
      East_FT  := East_M  * Meter_to_Feet;
         
   
   end Convert_Lat_Long_RAD_To_North_East_FT;
   
   procedure Convert_Lat_Long_DEG_To_North_East_M
     (
      Latitude_DEG  : in Long_float;
      Longitude_DEG : in Long_float;
      North_M      : out Long_float;
      East_M       : out Long_float)
   is 
      -- double dLatitude_rad = dLatitude_deg * n_Const::c_Convert::dDegreesToRadians();
      -- double dLongitude_rad = dLongitude_deg * n_Const::c_Convert::dDegreesToRadians();

      Latitude_RAD  : constant Long_float := Latitude_DEG * Degrees_to_Radians;
      Longitude_RAD : constant Long_float := Longitude_DEG * Degrees_to_Radians;
   begin
      
      --  if (!m_bInitialized){Initialize(dLatitude_rad, dLongitude_rad);  }
      if not B_Initilized then
         Initialize(Latitude_RAD,Longitude_RAD);
      end if;
      
      -- double dNorth_m = m_dRadiusMeridional_m * (dLatitude_rad - m_dLatitudeInitial_rad);
      -- double dEast_m = m_dRadiusSmallCircleLatitude_m * (dLongitude_rad - m_dLongitudeInitial_rad);
      Convert_Lat_Long_RAD_To_North_East_M(Latitude_RAD, Longitude_RAD ,
                                           North_M , East_M);
   
   
   end Convert_Lat_Long_DEG_To_North_East_M;

   procedure Convert_Lat_Long_DEG_To_North_East_FT
     (Latitude_DEG  : in Long_float;
      Longitude_DEG : in Long_float;
      North_FT     : out Long_float;
      East_FT      : out Long_float)
   is 
      -- double dLatitude_rad = dLatitude_deg * n_Const::c_Convert::dDegreesToRadians();
      -- double dLongitude_rad = dLongitude_deg * n_Const::c_Convert::dDegreesToRadians();
      Latitude_RAD  : constant Long_float := Latitude_DEG * Degrees_to_Radians;
      Longitude_RAD : constant Long_float := Longitude_DEG * Degrees_to_Radians;
      
      North_M : Long_float; 
      East_M  : Long_float;
   begin
      --  if (!m_bInitialized){Initialize(dLatitude_rad, dLongitude_rad);  }
      if not B_Initilized then
         Initialize(Latitude_RAD,Longitude_RAD);
      end if;
      -- double dNorth_m = m_dRadiusMeridional_m * (dLatitude_rad - m_dLatitudeInitial_rad);
      -- double dEast_m = m_dRadiusSmallCircleLatitude_m * (dLongitude_rad - m_dLongitudeInitial_rad);
      Convert_Lat_Long_RAD_To_North_East_M(Latitude_RAD, Longitude_RAD ,
                                           North_M , East_M);
      -- dNorth_m = m_dRadiusMeridional_m * (dLatitude_rad - m_dLatitudeInitial_rad);
      -- dEast_m = m_dRadiusSmallCircleLatitude_m * (dLongitude_rad - m_dLongitudeInitial_rad);
      North_FT := North_M * Meter_to_Feet;
      East_FT  := East_M  * Meter_to_Feet;
   
   end Convert_Lat_Long_DEG_To_North_East_FT;


   
   -- ////////////////////////////////////////////////////////////////////////////
   -- ///////     FROM NORTH/EAST TO LAT/LONG

   procedure Convert_North_East_M_To_Lat_Long_RAD
     (North_M      : in Long_float;
      East_M       : in Long_float;
      Latitude_RAD  : out Long_float;
      Longitude_RAD : out Long_float)
   is
   begin
      Latitude_RAD  := (if (Radius_Meridional_M <= 0.0) then 0.0 else
                          ((North_M / Radius_Meridional_M) + Latitude_Initial_RAD));
      Longitude_RAD := (if (Radius_Small_Circle_Latitude_M <= 0.0) then 0.0 else
                          ((East_M / Radius_Small_Circle_Latitude_M) + Longitude_Initial_RAD));
   end Convert_North_East_M_To_Lat_Long_RAD;
   
   procedure Convert_North_East_M_To_Lat_Long_DEG
     (North_M       : in  Long_float;
      East_M        : in  Long_float;
      Latitude_DEG  : out Long_float;
      Longitude_DEG : out Long_float)
   is 
      Latitude_RAD  : Long_Float;
      Longitude_RAD : Long_Float;
   begin
   
      Convert_North_East_M_To_Lat_Long_RAD(North_M,East_M,
                                           Latitude_RAD,Longitude_RAD);
   
      Latitude_DEG  := Latitude_RAD  * Radians_To_Degrees;
      Longitude_DEG := Longitude_RAD * Radians_To_Degrees;
   end  Convert_North_East_M_To_Lat_Long_DEG;

   procedure Convert_North_East_FT_To_Lat_Long_RAD
     (North_FT      : in Long_float;
      East_FT       : in Long_float;
      Latitude_RAD  : out Long_float;
      Longitude_RAD : out Long_float)
   is
      North_M : constant Long_float := North_FT * Feet_to_Meter;
      East_M  : constant Long_float := East_FT  * Feet_to_Meter;
   begin
  
      Convert_North_East_M_To_Lat_Long_RAD(North_M,East_M,
                                           Latitude_RAD,Longitude_RAD);
   end Convert_North_East_FT_To_Lat_Long_RAD;

   procedure Convert_North_East_FT_To_Lat_Long_DEG
     (North_FT      : in  Long_float;
      East_FT       : in  Long_float;
      Latitude_DEG  : out Long_float;
      Longitude_DEG : out Long_float)
   is
      North_M : constant Long_float := North_FT * Feet_to_Meter;
      East_M  : constant Long_float := East_FT  * Feet_to_Meter;
      Latitude_RAD  : Long_Float;
      Longitude_RAD : Long_Float;
   begin
   
      Convert_North_East_M_To_Lat_Long_RAD(North_M,East_M,
                                           Latitude_RAD,Longitude_RAD);
   
      Latitude_DEG  := Latitude_RAD  * Radians_To_Degrees;
      Longitude_DEG := Longitude_RAD * Radians_To_Degrees;
   end Convert_North_East_FT_To_Lat_Long_DEG;


   -- ////////////////////////////////////////////////////////////////////////////
   -- ///////     LINEAR DISTANCES

   procedure Get_Linear_Distance_M_Lat1_Long1_RAD_To_Lat2_Long2_RAD
     (Latitude_1_RAD    : in  Long_float;
      Longitude_1_RAD   : in  Long_float;
      Latitude_2_RAD    : in  Long_float;
      Longitude_2_RAD   : in  Long_float;
      Linear_Distance_M : out Long_Float)
   is
      North_1_M : Long_float;
      East_1_M  : Long_float;
      North_2_M : Long_float;
      East_2_M  : Long_float;
   
   begin
      -- ConvertLatLong_radToNorthEast_m(dLatitude1_rad, dLongitude1_rad, dNorth1_m, dEast1_m);
      Convert_Lat_Long_RAD_To_North_East_M(Latitude_1_RAD,
                                           Longitude_1_RAD,
                                           North_1_M,
                                           East_1_M);
   
      -- ConvertLatLong_radToNorthEast_m(dLatitude2_rad, dLongitude2_rad, dNorth2_m, dEast2_m);
      Convert_Lat_Long_RAD_To_North_East_M(
                                           Latitude_2_RAD,
                                           Longitude_2_RAD,
                                           North_2_M,
                                           East_2_M);
      
      -- double dReturn = std::pow((std::pow((dNorth2_m - dNorth1_m), 2.0) + std::pow((dEast2_m - dEast1_m), 2.0)), 0.5);
      Linear_Distance_M := (((North_2_M - North_1_M) ** 2.0) + (( East_2_M * East_1_M) **2.0))**0.5;

      
   end Get_Linear_Distance_M_Lat1_Long1_RAD_To_Lat2_Long2_RAD;

   procedure Get_Linear_Distance_M_Lat1_Long1_DEG_To_Lat2_Long2_DEG
     (Latitude_1_DEG    : in  Long_float;
      Longitude_1_DEG   : in  Long_float;
      Latitude_2_DEG    : in  Long_float;
      Longitude_2_DEG   : in  Long_float;
      Linear_Distance_M : out Long_Float)
   is
      Latitude_1_RAD  : constant Long_float := Latitude_1_DEG  * Degrees_to_Radians;
      Longitude_1_RAD : constant Long_float := Longitude_1_DEG * Degrees_to_Radians;
      Latitude_2_RAD  : constant Long_float := Latitude_2_DEG  * Degrees_to_Radians;
      Longitude_2_RAD : constant Long_float := Longitude_2_DEG * Degrees_to_Radians;
   
   begin
   
      Get_Linear_Distance_M_Lat1_Long1_RAD_To_Lat2_Long2_RAD(Latitude_1_RAD    => Latitude_1_RAD,
                                                             Longitude_1_RAD   => Longitude_1_RAD,
                                                             Latitude_2_RAD    => Latitude_2_RAD,
                                                             Longitude_2_RAD   => Longitude_2_RAD,
                                                             Linear_Distance_M => Linear_Distance_M);
   end Get_Linear_Distance_M_Lat1_Long1_DEG_To_Lat2_Long2_DEG;
                                             

end Uxas.Common.Utilities.Unit_Conversions;
