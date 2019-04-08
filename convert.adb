with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Numerics.Long_Complex_Elementary_Functions; use  Ada.Numerics.Long_Complex_Elementary_Functions;

package body convert is

   function Compare(Argument1 : Long_Float;
                    Argument2 : Long_Float;
                    rel_Operator : En_Relational_Operators;
                    Epsilon   : Long_Float :=(10.0**(-9)) ) return Boolean
   is
   begin
      
         
      case rel_Operator is 
         -- bReturn = (dArgument1 > dArgument2);
         when  enGreater      =>  return Argument1 > Argument2;
               
            --  bReturn = (bCompareDouble(dArgument1, dArgument2, enGreater) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when enGreaterEqual =>  return(Compare(Argument1,Argument2,enGreater)
                                        or 
                                          Compare(Argument1,Argument2,enEqual,Epsilon));
               
            -- bReturn = (dArgument1 < dArgument2);   
         when enLess         => return (Argument1 < Argument2);
               
            -- bReturn = (bCompareDouble(dArgument1, dArgument2, enLess) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when enLessEqual    => return (Compare(Argument1,Argument2,enLess)
                                        or 
                                          Compare(Argument1,Argument2,enEqual,Epsilon));
               
            --  bReturn = (std::fabs(dArgument1 - dArgument2) <= dEpsilon);
         when others        => return (abs(Argument1 - Argument2) <= Epsilon);
      end case;
         
   end Compare;
   
   function Compare(Argument1 : Float;
                    Argument2 : Float;
                    rel_Operator : En_Relational_Operators;
                    Epsilon   : Float := (10.0**(-9))) return Boolean
   
   is
   begin
         
      case rel_Operator is 
         -- bReturn = (dArgument1 > dArgument2);
         when  enGreater      =>  return Argument1 > Argument2;
               
            --  bReturn = (bCompareDouble(dArgument1, dArgument2, enGreater) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when enGreaterEqual =>  return(Compare(Argument1,Argument2,enGreater)
                                        or 
                                          Compare(Argument1,Argument2,enEqual,Epsilon));
               
            -- bReturn = (dArgument1 < dArgument2);   
         when enLess         => return (Argument1 < Argument2);
               
            -- bReturn = (bCompareDouble(dArgument1, dArgument2, enLess) || bCompareDouble(dArgument1, dArgument2, enEqual, dEpsilon));
         when enLessEqual    => return (Compare(Argument1,Argument2,enLess)
                                        or 
                                          Compare(Argument1,Argument2,enEqual,Epsilon));
               
            --  bReturn = (std::fabs(dArgument1 - dArgument2) <= dEpsilon);
         when others        => return (abs(Argument1 - Argument2) <= Epsilon);
      end case;
   end Compare;
   
   function Normalize_Angle_RAD( Angle_RAD : Long_Float;
                                 Angle_Reference : Long_Float := - Pi ) return Long_Float is
      
      -- double dModAngle = std::fmod(dAngleRad,dTwoPi());
      Mod_Angle : Long_Float := Angle_RAD mod Two_Pi;
   begin
      
      -- if( bCompareDouble(dModAngle, dAngleReference, enLess) )
      if Compare( Mod_Angle , Angle_Reference , enLess) then
         
         --  dModAngle += dTwoPi();
         Mod_Angle := Mod_Angle + Two_Pi;
         
         
         --  else if( bCompareDouble(dModAngle, (dAngleReference+dTwoPi()), enGreaterEqual) )   
      elsif Compare( Mod_Angle , Angle_Reference + Two_Pi , enGreaterEqual) then
         
         
         -- dModAngle -= dTwoPi();
         Mod_Angle := Mod_Angle - Two_Pi;
         
      end if;
      
      return Mod_Angle;
      
   end Normalize_Angle_RAD;
   
   function Normalize_Angle_Deg( Angle_RAD : Long_Float;
                                 Angle_Reference : Long_Float := - 180.0 ) return Long_Float is
      
      -- double dModAngle = std::fmod(dAngleRad,dTwoPi());
      Mod_Angle : Long_Float := Angle_RAD mod Long_Float(360.0);
   begin
      
      -- if( bCompareDouble(dModAngle, dAngleReference, enLess) )
      if Compare( Mod_Angle , Angle_Reference , enLess) then
         
         --  dModAngle += dTwoPi();
         Mod_Angle := Mod_Angle + 360.0;
         
         
         --  else if( bCompareDouble(dModAngle, (dAngleReference+dTwoPi()), enGreaterEqual) )   
      elsif Compare( Mod_Angle , Angle_Reference + 360.0 , enGreaterEqual) then
         
         
         -- dModAngle -= dTwoPi();
         Mod_Angle := Mod_Angle - 360.0;
         
      end if;
      
      return Mod_Angle;
      
   end Normalize_Angle_Deg;
   
     
   function Normalize_Angle_RAD( Angle_RAD : Float;
                                 Angle_Reference : Float := Float( - Pi) ) return Float is
      
      -- double dModAngle = std::fmod(dAngleRad,dTwoPi());
      Mod_Angle : Float := Angle_RAD mod Float(Two_Pi);
   begin
      
      -- if( bCompareDouble(dModAngle, dAngleReference, enLess) )
      if Compare( Mod_Angle , Angle_Reference , enLess) then
         
         --  dModAngle += dTwoPi();
         Mod_Angle := Mod_Angle + Float(Two_Pi);
         
         
         --  else if( bCompareDouble(dModAngle, (dAngleReference+dTwoPi()), enGreaterEqual) )   
      elsif Compare( Mod_Angle , Angle_Reference + Float(Two_Pi) , enGreaterEqual) then
         
         
         -- dModAngle -= dTwoPi();
         Mod_Angle := Mod_Angle - Float(Two_Pi);
         
      end if;
      
      return Mod_Angle;
      
   end Normalize_Angle_RAD;
   
   function Normalize_Angle_Deg( Angle_RAD : Float;
                                 Angle_Reference : Float := - 180.0 ) return Float is
      
      -- double dModAngle = std::fmod(dAngleRad,dTwoPi());
      Mod_Angle : Float := Angle_RAD mod 360.0;
   begin
      
      -- if( bCompareDouble(dModAngle, dAngleReference, enLess) )
      if Compare( Mod_Angle , Angle_Reference , enLess) then
         
         --  dModAngle += dTwoPi();
         Mod_Angle := Mod_Angle + 360.0;
         
         
         --  else if( bCompareDouble(dModAngle, (dAngleReference+dTwoPi()), enGreaterEqual) )   
      elsif Compare( Mod_Angle , Angle_Reference + 360.0 , enGreaterEqual) then
         
         
         -- dModAngle -= dTwoPi();
         Mod_Angle := Mod_Angle - 360.0;
         
      end if;
      
      return Mod_Angle;
      
   end Normalize_Angle_Deg;
   
   -- static void vRound(double& rdNumber,const double dDecimalPlace)
   procedure vRound(Number : in out Long_Float; 
                    Decimel_Place : in Long_Float)is 
   begin
      Number := dRound(Number        => Number,
                       Decimal_Place => Decimel_Place);
   end vRound;
        
                      
      

end convert;
