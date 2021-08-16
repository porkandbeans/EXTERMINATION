package guns;

class Gun{
    public var ammo:Int;
    public var MAX_AMMO:Int;

    public function shoot(x:Float, y:Float, f:Bool){
        ammo--;
    }
}
