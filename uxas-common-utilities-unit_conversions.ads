
with ADA.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

package Uxas.Common.Utilities.Unit_Conversions  with SPARK_Mode is

   
  
   --type Unit_Conversions_Ref is  access all Unit_Conversions'Class;
   
   procedure Initialize(Latitude_Init_RAD     : in Long_float;
                        Longitude_Init_RAD : in Long_float);
   procedure Re_Initialize (Latitude_Init_RAD     : in Long_float;
                            Longitude_Init_RAD : in Long_float);
   
      
   -- ////////////////////////////////////////////////////////////////////////////
   -- ///////    FROM LAT/LONG TO NORTH/EAST
   
   procedure Convert_Lat_Long_RAD_To_North_East_M
     (Latitude_RAD  : in Long_float;
      Longitude_RAD : in Long_float;
      North_M      : out Long_float;
      East_M       : out Long_float);
   procedure Convert_Lat_Long_RAD_To_North_East_FT
     (Latitude_RAD  : in Long_float;
      Longitude_RAD : in Long_float;
      North_FT     : out Long_float;
      East_FT      : out Long_float);  
   procedure Convert_Lat_Long_DEG_To_North_East_M
     (Latitude_DEG  : in Long_float;
      Longitude_DEG : in Long_float;
      North_M      : out Long_float;
      East_M       : out Long_float);
   procedure Convert_Lat_Long_DEG_To_North_East_FT
     (Latitude_DEG  : in Long_float;
      Longitude_DEG : in Long_float;
      North_FT     : out Long_float;
      East_FT      : out Long_float);
  

   -- ////////////////////////////////////////////////////////////////////////////
   -- ///////     FROM NORTH/EAST TO LAT/LONG
   
   procedure Convert_North_East_M_To_Lat_Long_RAD
     (North_M      : in Long_float;
      East_M       : in Long_float;
      Latitude_RAD  : out Long_float;
      Longitude_RAD : out Long_float) with 
     Global => (Radius_Meridional_M , Latitude_Initial_RAD
                ,Radius_Small_Circle_Latitude_M,Longitude_Initial_RAD),
     pre => (Radius_Meridional_M > 0.0) 
     and    (Radius_Small_Circle_Latitude_M > 0.0) ;
   
   
   procedure Convert_North_East_M_To_Lat_Long_DEG
     (North_M      : in Long_float;
      East_M       : in Long_float;
      Latitude_DEG  : out Long_float;
      Longitude_DEG : out Long_float) with 
     Global => (Radius_Meridional_M , Latitude_Initial_RAD
                ,Radius_Small_Circle_Latitude_M,Longitude_Initial_RAD),
     pre => Radius_Meridional_M > 0.0 
     and  Radius_Small_Circle_Latitude_M >0.0 ;

   procedure Convert_North_East_FT_To_Lat_Long_DEG
     (North_FT      : in Long_float;
      East_FT       : in Long_float;
      Latitude_DEG  : out Long_float;
      Longitude_DEG : out Long_float) with 
     Global => (Radius_Meridional_M , Latitude_Initial_RAD
                ,Radius_Small_Circle_Latitude_M,Longitude_Initial_RAD),
     pre => Radius_Meridional_M > 0.0 
     and  Radius_Small_Circle_Latitude_M > 0.0 ;
   
   -- void ConvertNorthEast_ftToLatLong_deg(const Long_float& dNorth_ft, const Long_float& dEast_ft, Long_float& dLatitude_deg, Long_float& dLongitude_deg); 
   procedure Convert_North_East_FT_To_Lat_Long_RAD
     (North_FT      : in Long_float;
      East_FT       : in Long_float;
      Latitude_RAD  : out Long_float;
      Longitude_RAD : out Long_float) with 
     Global => (Radius_Meridional_M , Latitude_Initial_RAD
                ,Radius_Small_Circle_Latitude_M,Longitude_Initial_RAD),
     pre => Radius_Meridional_M > 0.0 
     and  Radius_Small_Circle_Latitude_M >0.0 ;
   
   -- ////////////////////////////////////////////////////////////////////////////
   -- ///////     LINEAR DISTANCES
   
   
   -- Long_float dGetLinearDistance_m_Lat1Long1_RAD_To_Lat2Long2_rad(const Long_float& dLatitude1_rad, const Long_float& dLongitude1_rad, const Long_float& dLatitude2_rad, const Long_float& dLongitude2_rad);
   procedure Get_Linear_Distance_M_Lat1_Long1_RAD_To_Lat2_Long2_RAD
     (Latitude_1_RAD    : in  Long_float;
      Longitude_1_RAD   : in  Long_float;
      Latitude_2_RAD    : in  Long_float;
      Longitude_2_RAD   : in  Long_float;
      Linear_Distance_M : out Long_Float);
   
   
   --  Long_float dGetLinearDistance_m_Lat1Long1_deg_To_Lat2Long2_deg(const Long_float& dLatitude1_deg, const Long_float& dLongitude1_deg, const Long_float& dLatitude2_deg, const Long_float& dLongitude2_deg);
   procedure Get_Linear_Distance_M_Lat1_Long1_DEG_To_Lat2_Long2_DEG
     (Latitude_1_DEG    : in  Long_float;
      Longitude_1_DEG   : in  Long_float;
      Latitude_2_DEG    : in  Long_float;
      Longitude_2_DEG   : in  Long_float;
      Linear_Distance_M : out Long_Float);
   

   
   --  // WGS-84 parameters
  
   -- const Long_float m_dRadiusEquatorial_m{6378135.0};
   Radius_Equatorial_M  : constant Long_float := 6378135.0; 
   -- const Long_float m_dFlattening{3.352810664724998e-003};
   Flattening           : constant Long_float := Long_Float(0.003352810664724998);
   -- const Long_float m_dEccentricitySquared{6.694379990096503e-003};
   Eccentricity_Squared : constant Long_float := Long_Float(0.006694379990096503);


   Latitude_Initial_RAD           : Long_float  := 0.0;   --  double CUnitConversions::m_dLatitudeInitial_rad{0.0};
   Longitude_Initial_RAD          : Long_float  := 0.0;   --  double CUnitConversions::m_dLongitudeInitial_rad{0.0};
   Radius_Meridional_M            : Long_float  := 0.0;   --  double CUnitConversions::m_dRadiusMeridional_m{0.0};
   Radius_Transverse_M            : Long_float  := 0.0;   --  double CUnitConversions::m_dRadiusTransverse_m{0.0};
   Radius_Small_Circle_Latitude_M : Long_float  := 0.0;   --  double CUnitConversions::m_dRadiusSmallCircleLatitude_m{0.0};
   B_Initilized                   : Boolean  := False;    --  bool   CUnitConversions::m_bInitialized{false};
   


end Uxas.Common.Utilities.Unit_Conversions;
