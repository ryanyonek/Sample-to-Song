// Score File, calling all of the other parts, lining them up with the Machine() function

me.dir() + "trombone.ck:1" => string bone1Filename;
Machine.add(bone1Filename) => int bone1ID;

me.dir() + "trombone.ck:2" => string bone2Filename;
Machine.add(bone2Filename) => int bone2ID;

me.dir() + "trombone.ck:3" => string bone3Filename;
Machine.add(bone3Filename) => int bone3ID;

me.dir() + "trombone.ck:4" => string bone4Filename;
Machine.add(bone4Filename) => int bone4ID;

/*
Before Command Line Arguments were inplemented
Needed 4 different .ck files

me.dir() + "bone2.ck" => string bone2Filename;
Machine.add(bone2Filename) => int bone2ID;

me.dir() + "bone3.ck" => string bone3Filename;
Machine.add(bone3Filename) => int bone3ID;

me.dir() + "bone4.ck" => string bone4Filename;
Machine.add(bone4Filename) => int bone4ID;
*/