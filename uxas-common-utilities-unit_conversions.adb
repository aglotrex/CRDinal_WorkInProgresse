with UxAS.Common.Utilities.Unit_Conversions;    use UxAS.Common.Utilities.Unit_Conversions;
--  with ADA.Numerics.Elementary_Functions;         use ADA.Numerics.Elementary_Functions;
with Ada.Numerics.Long_Elementary_Functions; use  Ada.Numerics.Long_Elementary_Functions;

package body Uxas.Common.Utilities.Unit_Conversions with SPARK_Mode => Off is
   
   
   
   procedure Initialize( This : in out Unit_Conversions;
                         D_Latitude_Init_RAD  : in Long_float;
                         D_Longitude_Init_RAD : in Long_float)
   is 
   begin
      if This.B_Initilized then
         
         -- m_dLatitudeInitial_rad  = dLatitudeInit_rad;
         -- m_dLongitudeInitial_rad = dLongitudeInit_rad;
         This.D_Latitude_Initial_RAD  := D_Latitude_Init_RAD;
         THis.D_Longitude_Initial_RAD := D_Longitude_Init_RAD;
        
         
         declare
            -- double dDenominatorMeridional = std::pow((1.0 - (m_dEccentricitySquared * std::pow(std::sin(dLatitudeInit_rad), 2.0))), (3.0 / 2.0));
            -- double dDenominatorTransverse = pow((1.0 - (m_dEccentricitySquared * std::pow(std::sin(dLatitudeInit_rad), 2.0))), 0.5);
            Denominator_Meridional : constant Long_float := (1.0 -(D_Eccentricity_Squared 
                                                             * (Sin(D_Latitude_Init_RAD)**Long_Float(2.0))))**(3.0/2.0);
            Denominator_Transverse :constant  Long_float := (1.0 -(D_Eccentricity_Squared 
                                                             * (Sin(D_Latitude_Init_RAD)**2.0)))**(0.5);
          
         begin
            -- assert(dDenominatorMeridional > 0.0);
            -- assert(dDenominatorTransverse > 0.0);
            pragma Assert(Denominator_Meridional > 0.0);
            pragma Assert(Denominator_Transverse > 0.0);
            
            
            -- Long_float dDenominatorTransverse = pow((1.0 - (m_dEccentricitySquared * std::pow(std::sin(dLatitudeInit_rad), 2.0))), 0.5);
            This.D_Radius_Meridional_M := (if Denominator_Meridional <= 0.0 
                                           then 0.0 
                                           else D_Radius_Equatorial_M * ( 1.0 - D_Eccentricity_Squared) / Denominator_Meridional);
            
            --  m_dRadiusTransverse_m = (dDenominatorTransverse <= 0.0) ? (0.0) : (m_dRadiusEquatorial_m / dDenominatorTransverse);
            This.D_Radius_Transverse_M := (if Denominator_Transverse <= 0.0 
                                           then 0.0 
                                           else D_Radius_Equatorial_M / Denominator_Transverse);
            
            --  m_dRadiusSmallCircleLatitude_m = m_dRadiusTransverse_m * cos(dLatitudeInit_rad);
            This.D_Radius_Small_Circle_Latitude_M := (This.D_Radius_Transverse_M 
                                                      * Cos(X => D_Latitude_Init_RAD));
            
            
            This.B_Initilized := True; 
         end;
         
      end if;
   end Initialize;
   
   
   procedure Re_Initialize( This : in out Unit_Conversions;
                            D_Latitude_Init_RAD  : in Long_float;
                            D_Longitude_Init_RAD : in Long_float)
   is null;
   --  begin
      
   --  //    m_bInitialized = false;
   --  //    Initialize(dLatitudeInit_rad,dLongitudeInit_rad);
   --  //#error "ERROR: CUnitConversions::ReInitialize::   reiitialize is no longer allowed!!!" 
      
   --        THis.B_Initilized := False;
   --        This.Initialize(D_Latitude_Init_RAD => D_Latitude_Init_RAD,
   --                        D_Longitude_Init_RAD =>D_Longitude_Init_RAD);
   --  end Re_Initialize;
            
        
      
   -- ////////////////////////////////////////////////////////////////////////////
   -- ///////    FROM LAT/LONG TO NORTH/EAST
   
   procedure Convert_Lag_Long_RAD_To_North_East_M
     (This : in out Unit_Conversions;
      D_Latitude_RAD  : in Long_float;
      D_Longitude_RAD : in Long_float;
      D_North_M      : out Long_float;
      D_East_M       : out Long_float)
   is
   begin
      
      --    if (!m_bInitialized){Initialize(dLatitude_rad, dLongitude_rad);  }
      if not this.B_Initilized then
         Initialize(This,D_Latitude_RAD,D_Longitude_RAD);
      end if;
      
      -- dNorth_m = m_dRadiusMeridional_m * (dLatitude_rad - m_dLatitudeInitial_rad);
      -- dEast_m = m_dRadiusSmallCircleLatitude_m * (dLongitude_rad - m_dLongitudeInitial_rad);
      D_North_M := This.D_Radius_Meridional_M * (D_Latitude_RAD - This.D_Latitude_Initial_RAD);
      D_East_M  := This.D_Radius_Small_Circle_Latitude_M * (D_Longitude_RAD - This.D_Longitude_Initial_RAD);
   end Convert_Lag_Long_RAD_To_North_East_M;
   
   procedure Convert_Lag_Long_RAD_To_North_East_FT
     (This : in out Unit_Conversions;
      D_Latitude_RAD  : in Long_float;
      D_Longitude_RAD : in Long_float;
      D_North_FT     : out Long_float;
      D_East_FT      : out Long_float)
   is 
   begin
      
      --  if (!m_bInitialized){Initialize(dLatitude_rad, dLongitude_rad);  }
      if not this.B_Initilized then
         Initialize(This,D_Latitude_RAD,D_Longitude_RAD);
      end if;
      declare 
         
         -- double dNorth_m = m_dRadiusMeridional_m * (dLatitude_rad - m_dLatitudeInitial_rad);
         -- double dEast_m = m_dRadiusSmallCircleLatitude_m * (dLongitude_rad - m_dLongitudeInitial_rad);
         D_North_M : constant Long_float := This.D_Radius_Meridional_M * (D_Latitude_RAD - This.D_Latitude_Initial_RAD);
         D_East_M  : constant Long_float := This.D_Radius_Small_Circle_Latitude_M * (D_Longitude_RAD - This.D_Longitude_Initial_RAD);
      
      begin 
         -- dNorth_m = m_dRadiusMeridional_m * (dLatitude_rad - m_dLatitudeInitial_rad);
         -- dEast_m = m_dRadiusSmallCircleLatitude_m * (dLongitude_rad - m_dLongitudeInitial_rad);
         D_North_FT := D_North_M * D_Meter_to_Feet;
         D_East_FT  := D_East_M  * D_Meter_to_Feet;
         
      end;
   end Convert_Lag_Long_RAD_To_North_East_FT;
   
   procedure Convert_Lag_Long_DEG_To_North_East_M
     (This : in out Unit_Conversions;
      D_Latitude_DEG  : in Long_float;
      D_Longitude_DEG : in Long_float;
      D_North_M      : out Long_float;
      D_East_M       : out Long_float)
   is 
      -- double dLatitude_rad = dLatitude_deg * n_Const::c_Convert::dDegreesToRadians();
      -- double dLongitude_rad = dLongitude_deg * n_Const::c_Convert::dDegreesToRadians();

      D_Latitude_RAD  : constant Long_float := D_Latitude_DEG * D_Degre_to_Radian;
      D_Longitude_RAD : constant Long_float := D_Longitude_DEG * D_Degre_to_Radian;
   begin
      
      --  if (!m_bInitialized){Initialize(dLatitude_rad, dLongitude_rad);  }
      if not this.B_Initilized then
         Initialize(This,D_Latitude_RAD,D_Longitude_RAD);
      end if;
      -- dNorth_m = m_dRadiusMeridional_m * (dLatitude_rad - m_dLatitudeInitial_rad);
      -- dEast_m = m_dRadiusSmallCircleLatitude_m * (dLongitude_rad - m_dLongitudeInitial_rad);
      D_North_M  := This.D_Radius_Meridional_M * (D_Latitude_RAD - This.D_Latitude_Initial_RAD);
      D_East_M   := This.D_Radius_Small_Circle_Latitude_M * (D_Longitude_RAD - This.D_Longitude_Initial_RAD);
   
   
   end Convert_Lag_Long_DEG_To_North_East_M;

   procedure Convert_Lag_Long_DEG_To_North_East_FT
     (This : in out Unit_Conversions;
      D_Latitude_DEG  : in Long_float;
      D_Longitude_DEG : in Long_float;
      D_North_FT     : out Long_float;
      D_East_FT      : out Long_float)
   is 
      -- double dLatitude_rad = dLatitude_deg * n_Const::c_Convert::dDegreesToRadians();
      -- double dLongitude_rad = dLongitude_deg * n_Const::c_Convert::dDegreesToRadians();
      D_Latitude_RAD  : constant Long_float := D_Latitude_DEG * D_Degre_to_Radian;
      D_Longitude_RAD : constant Long_float := D_Longitude_DEG * D_Degre_to_Radian;
   begin
      --  if (!m_bInitialized){Initialize(dLatitude_rad, dLongitude_rad);  }
      if not this.B_Initilized then
         Initialize(This,D_Latitude_RAD,D_Longitude_RAD);
      end if;
      declare 
         -- double dNorth_m = m_dRadiusMeridional_m * (dLatitude_rad - m_dLatitudeInitial_rad);
         -- double dEast_m = m_dRadiusSmallCircleLatitude_m * (dLongitude_rad - m_dLongitudeInitial_rad);
      
         D_North_M : constant Long_float := This.D_Radius_Meridional_M * (D_Latitude_RAD - This.D_Latitude_Initial_RAD);
         D_East_M  : constant Long_float := This.D_Radius_Small_Circle_Latitude_M * (D_Longitude_RAD - This.D_Longitude_Initial_RAD);
      begin 
        
         -- dNorth_m = m_dRadiusMeridional_m * (dLatitude_rad - m_dLatitudeInitial_rad);
         -- dEast_m = m_dRadiusSmallCircleLatitude_m * (dLongitude_rad - m_dLongitudeInitial_rad);
         D_North_FT := D_North_M * D_Meter_to_Feet;
         D_East_FT  := D_East_M  * D_Meter_to_Feet;
      end;
   end Convert_Lag_Long_DEG_To_North_East_FT;


   
   -- ////////////////////////////////////////////////////////////////////////////
   -- ///////     FROM NORTH/EAST TO LAT/LONG

   procedure Convert_North_East_M_To_Lag_Long_RAD
     (This : in Unit_Conversions;
      D_North_M      : in Long_float;
      D_East_M       : in Long_float;
      D_Latitude_RAD  : out Long_float;
      D_Longitude_RAD : out Long_float)
   is
   begin
      D_Latitude_RAD  := (if (This.D_Radius_Meridional_M <= 0.0) then 0.0 else
                            ((D_North_M / This.D_Radius_Meridional_M) + This.D_Latitude_Initial_RAD));
      D_Longitude_RAD := (if (This.D_Radius_Small_Circle_Latitude_M <= 0.0) then 0.0 else
                            ((D_East_M / This.D_Radius_Small_Circle_Latitude_M) + This.D_Longitude_Initial_RAD));
   end Convert_North_East_M_To_Lag_Long_RAD;
   
   procedure Convert_North_East_M_To_Lag_Long_DEG
     (This : in Unit_Conversions;
      D_North_M      : in Long_float;
      D_East_M       : in Long_float;
      D_Latitude_DEG  : out Long_float;
      D_Longitude_DEG : out Long_float)
   is 
   begin
   
      D_Latitude_DEG  := (if (This.D_Radius_Meridional_M <= 0.0) then 0.0 else
                            (((D_North_M / This.D_Radius_Meridional_M) + This.D_Latitude_Initial_RAD)
                             * D_Radian_to_Degre));
      D_Longitude_DEG := (if (This.D_Radius_Small_Circle_Latitude_M <= 0.0) then 0.0 else
                            (((D_East_M / This.D_Radius_Small_Circle_Latitude_M) + This.D_Longitude_Initial_RAD)
                             * D_Radian_to_Degre));
   end  Convert_North_East_M_To_Lag_Long_DEG;

   procedure Convert_North_East_FT_To_Lag_Long_RAD
     (This : in Unit_Conversions;
      D_North_FT      : in Long_float;
      D_East_FT       : in Long_float;
      D_Latitude_RAD  : out Long_float;
      D_Longitude_RAD : out Long_float)
   is
      D_North_M : constant Long_float := D_North_FT * D_Feet_to_Meter;
      D_East_M  : constant Long_float := D_East_FT  * D_Feet_to_Meter;
   begin
      D_Latitude_RAD  := (if (This.D_Radius_Meridional_M <= 0.0) then 0.0 else
                            ((D_North_M / This.D_Radius_Meridional_M) + This.D_Latitude_Initial_RAD));
      D_Longitude_RAD := (if (This.D_Radius_Small_Circle_Latitude_M <= 0.0) then 0.0 else
                            ((D_East_M / This.D_Radius_Small_Circle_Latitude_M) + This.D_Longitude_Initial_RAD));
   end Convert_North_East_FT_To_Lag_Long_RAD;

   procedure Convert_North_East_FT_To_Lag_Long_DEG
     (This : in Unit_Conversions;
      D_North_FT      : in Long_float;
      D_East_FT       : in Long_float;
      D_Latitude_DEG  : out Long_float;
      D_Longitude_DEG : out Long_float)
   is
      D_North_M : constant Long_float := D_North_FT * D_Feet_to_Meter;
      D_East_M  : constant Long_float := D_East_FT  * D_Feet_to_Meter;
   begin
      
      D_Latitude_DEG  := (if (This.D_Radius_Meridional_M <= 0.0) then 0.0 else
                            (((D_North_M / This.D_Radius_Meridional_M) + This.D_Latitude_Initial_RAD)
                             * D_Radian_to_Degre));
   
      D_Longitude_DEG := (if (This.D_Radius_Small_Circle_Latitude_M <= 0.0) then 0.0 else
                            (((D_East_M / This.D_Radius_Small_Circle_Latitude_M) + This.D_Longitude_Initial_RAD)
                             * D_Radian_to_Degre));
   end Convert_North_East_FT_To_Lag_Long_DEG;


   -- ////////////////////////////////////////////////////////////////////////////
   -- ///////     LINEAR DISTANCES

   procedure D_Get_Linear_Distance_M_Lat1_Long1_RAD_To_Lat2_Long2_RAD
     (This : in out Unit_Conversions;
      D_Latitude_1_RAD    : in  Long_float;
      D_Longitude_1_RAD   : in  Long_float;
      D_Latitude_2_RAD    : in  Long_float;
      D_Longitude_2_RAD   : in  Long_float;
      D_Linear_Distance_M : out Long_Float)
   is
      D_North_1_M : Long_float;
      D_East_1_M  : Long_float;
      D_North_2_M : Long_float;
      D_East_2_M  : Long_float;
   
   begin
      -- ConvertLatLong_radToNorthEast_m(dLatitude1_rad, dLongitude1_rad, dNorth1_m, dEast1_m);
      Convert_Lag_Long_RAD_To_North_East_M(This,
                                           D_Latitude_1_RAD,
                                           D_Longitude_1_RAD,
                                           D_North_1_M,
                                           D_East_1_M);
   
      -- ConvertLatLong_radToNorthEast_m(dLatitude2_rad, dLongitude2_rad, dNorth2_m, dEast2_m);
      Convert_Lag_Long_RAD_To_North_East_M(This,
                                           D_Latitude_2_RAD,
                                           D_Longitude_2_RAD,
                                           D_North_2_M,
                                           D_East_2_M);
      
      -- double dReturn = std::pow((std::pow((dNorth2_m - dNorth1_m), 2.0) + std::pow((dEast2_m - dEast1_m), 2.0)), 0.5);
      D_Linear_Distance_M := (((D_North_2_M - D_North_1_M) ** 2.0) + (( D_East_2_M * D_East_1_M) **2.0))**0.5;

      
   end D_Get_Linear_Distance_M_Lat1_Long1_RAD_To_Lat2_Long2_RAD;

   procedure D_Get_Linear_Distance_M_Lat1_Long1_DEG_To_Lat2_Long2_DEG
     (This : in out Unit_Conversions;
      D_Latitude_1_DEG    : in  Long_float;
      D_Longitude_1_DEG   : in  Long_float;
      D_Latitude_2_DEG    : in  Long_float;
      D_Longitude_2_DEG   : in  Long_float;
      D_Linear_Distance_M : out Long_Float)
   is
      D_North_1_M : Long_float;
      D_East_1_M  : Long_float;
      D_North_2_M : Long_float;
      D_East_2_M  : Long_float;
   
   begin
      -- ConvertLatLong_radToNorthEast_m(dLatitude1_rad, dLongitude1_rad, dNorth1_m, dEast1_m);
      Convert_Lag_Long_DEG_To_North_East_M(This,
                                           D_Latitude_1_DEG,
                                           D_Longitude_1_DEG,
                                           D_North_1_M,
                                           D_East_1_M);
   
      -- ConvertLatLong_radToNorthEast_m(dLatitude2_rad, dLongitude2_rad, dNorth2_m, dEast2_m);
      Convert_Lag_Long_DEG_To_North_East_M(This,
                                           D_Latitude_2_DEG,
                                           D_Longitude_2_DEG,
                                           D_North_2_M,
                                           D_East_2_M);
      
      --   double dReturn = std::pow((std::pow((dNorth2_m - dNorth1_m), 2.0) + std::pow((dEast2_m - dEast1_m), 2.0)), 0.5);
      D_Linear_Distance_M := (((D_North_2_M - D_North_1_M) ** Long_Float(2.0))
                              + (( D_East_2_M * D_East_1_M) ** Long_Float(2.0)))
        **  Long_Float(0.5);
   end D_Get_Linear_Distance_M_Lat1_Long1_DEG_To_Lat2_Long2_DEG;
                                             

end Uxas.Common.Utilities.Unit_Conversions;
