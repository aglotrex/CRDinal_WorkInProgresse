
with ADA.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

package Uxas.Common.Utilities.Unit_Conversions  with SPARK_Mode is

   type Unit_Conversions is limited private;
  
   --type Unit_Conversions_Ref is  access all Unit_Conversions'Class;
   
   procedure Initialize( This : in out Unit_Conversions;
                         D_Latitude_Init_RAD     : in Long_float;
                         D_Longitude_Init_RAD : in Long_float);
   procedure Re_Initialize ( This : in out Unit_Conversions;
                             D_Latitude_Init_RAD     : in Long_float;
                             D_Longitude_Init_RAD : in Long_float);
   
      
   -- ////////////////////////////////////////////////////////////////////////////
   -- ///////    FROM LAT/LONG TO NORTH/EAST
   
   procedure Convert_Lag_Long_RAD_To_North_East_M
     (This : in out Unit_Conversions;
      D_Latitude_RAD  : in Long_float;
      D_Longitude_RAD : in Long_float;
      D_North_M      : out Long_float;
      D_East_M       : out Long_float);
   procedure Convert_Lag_Long_RAD_To_North_East_FT
     (This : in out Unit_Conversions;
      D_Latitude_RAD  : in Long_float;
      D_Longitude_RAD : in Long_float;
      D_North_FT     : out Long_float;
      D_East_FT      : out Long_float);  
   procedure Convert_Lag_Long_DEG_To_North_East_M
     (This : in out Unit_Conversions;
      D_Latitude_DEG  : in Long_float;
      D_Longitude_DEG : in Long_float;
      D_North_M      : out Long_float;
      D_East_M       : out Long_float);
   procedure Convert_Lag_Long_DEG_To_North_East_FT
     (This : in out Unit_Conversions;
      D_Latitude_DEG  : in Long_float;
      D_Longitude_DEG : in Long_float;
      D_North_FT     : out Long_float;
      D_East_FT      : out Long_float);
  
   
   
   -- ////////////////////////////////////////////////////////////////////////////
   -- ///////     FROM NORTH/EAST TO LAT/LONG
   
   procedure Convert_North_East_M_To_Lag_Long_RAD
     (This : in Unit_Conversions;
      D_North_M      : in Long_float;
      D_East_M       : in Long_float;
      D_Latitude_RAD  : out Long_float;
      D_Longitude_RAD : out Long_float) with 
     pre => (This.D_Radius_Meridional_M > 0.0) 
     and  (This.D_Radius_Small_Circle_Latitude_M > 0.0) ;
   
   
   procedure Convert_North_East_M_To_Lag_Long_DEG
     (This : in Unit_Conversions;
      D_North_M      : in Long_float;
      D_East_M       : in Long_float;
      D_Latitude_DEG  : out Long_float;
      D_Longitude_DEG : out Long_float) with 
     pre => This.D_Radius_Meridional_M > 0.0 
     and  This.D_Radius_Small_Circle_Latitude_M >0.0 ;

   procedure Convert_North_East_FT_To_Lag_Long_DEG
     (This : in Unit_Conversions;
      D_North_FT      : in Long_float;
      D_East_FT       : in Long_float;
      D_Latitude_DEG  : out Long_float;
      D_Longitude_DEG : out Long_float) with 
     pre => This.D_Radius_Meridional_M > 0.0 
     and  This.D_Radius_Small_Circle_Latitude_M >0.0 ;
   
   -- void ConvertNorthEast_ftToLatLong_deg(const Long_float& dNorth_ft, const Long_float& dEast_ft, Long_float& dLatitude_deg, Long_float& dLongitude_deg); 
   procedure Convert_North_East_FT_To_Lag_Long_RAD
     (This : in Unit_Conversions;
      D_North_FT      : in Long_float;
      D_East_FT       : in Long_float;
      D_Latitude_RAD  : out Long_float;
      D_Longitude_RAD : out Long_float) with 
     pre => This.D_Radius_Meridional_M > 0.0 
     and  This.D_Radius_Small_Circle_Latitude_M >0.0 ;
   
   -- ////////////////////////////////////////////////////////////////////////////
   -- ///////     LINEAR DISTANCES
   
   
   -- Long_float dGetLinearDistance_m_Lat1Long1_rad_To_Lat2Long2_rad(const Long_float& dLatitude1_rad, const Long_float& dLongitude1_rad, const Long_float& dLatitude2_rad, const Long_float& dLongitude2_rad);
   procedure D_Get_Linear_Distance_M_Lat1_Long1_RAD_To_Lat2_Long2_RAD
     (This : in out Unit_Conversions;
      D_Latitude_1_RAD    : in  Long_float;
      D_Longitude_1_RAD   : in  Long_float;
      D_Latitude_2_RAD    : in  Long_float;
      D_Longitude_2_RAD   : in  Long_float;
      D_Linear_Distance_M : out Long_Float);
   --  Long_float dGetLinearDistance_m_Lat1Long1_deg_To_Lat2Long2_deg(const Long_float& dLatitude1_deg, const Long_float& dLongitude1_deg, const Long_float& dLatitude2_deg, const Long_float& dLongitude2_deg);
   procedure D_Get_Linear_Distance_M_Lat1_Long1_DEG_To_Lat2_Long2_DEG
     (This : in out Unit_Conversions;
      D_Latitude_1_DEG    : in  Long_float;
      D_Longitude_1_DEG   : in  Long_float;
      D_Latitude_2_DEG    : in  Long_float;
      D_Longitude_2_DEG   : in  Long_float;
      D_Linear_Distance_M : out Long_Float);
   
private
   
   
    

   D_Meter_to_Feet : constant Long_float := 3.280839895;
   D_Feet_to_Meter : constant Long_float := 0.3048;
   
   D_Degre_to_Radian : constant Long_float := 0.01745329251994;
   D_Radian_to_Degre : constant Long_float := 57.29577951308232;
   
   --  // WGS-84 parameters
  
   -- const Long_float m_dRadiusEquatorial_m{6378135.0};
   D_Radius_Equatorial_M  : constant Long_float := 6378135.0; 
   -- const Long_float m_dFlattening{3.352810664724998e-003};
   D_Flattening           : constant Long_float := Long_Float(3.352810664724998*(10.0**(-3.0)));
   -- const Long_float m_dEccentricitySquared{6.694379990096503e-003};
   D_Eccentricity_Squared : constant Long_float := Long_Float(6.694379990096503*(10.0**(-3.0)));
   
   type Unit_Conversions is 
      record
         D_Latitude_Initial_RAD           : Long_float  := 0.0;
         D_Longitude_Initial_RAD          : Long_float  := 0.0;
         D_Radius_Meridional_M            : Long_float  := 0.0;
         D_Radius_Transverse_M            : Long_float  := 0.0;
         D_Radius_Small_Circle_Latitude_M : Long_float  := 0.0;
         B_Initilized                     : Boolean := False;
      end record;


end Uxas.Common.Utilities.Unit_Conversions;
