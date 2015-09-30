(********************YazevBattleTank 2: Metaller's Revenge*********************)
(************continuation of the YazevBattleTank game generation line**********)
(*******************which was begun in 2003 by Yazev Yuriy*********************)
(**************************new version ~!~!~!~ new game!!!*********************)
(************************now it's time for YazevBattleTank*********************)
(*************************************now 2006*********************************)
(*********new version of this game is supporting DirectInput and OpenGL********)
(***********DirectInput for a control, OpenGL for a graphics output************)
(********************************Yazev Yuriy's Game****************************)
(************************************YazevSoft*********************************)
(****************************Yazev Yuriy's YazevSoft***************************)
(**********************developed in YazevSoft by Yazev Yuriy*******************)
(****************************developed by Yazev Yuriy**************************)
(*******************************begin : 16.05.2006*****************************)
(********************************end : 16.07.2006******************************)
(*********I developed the game engine and game on it at 15.07.2006*************)
(*****************I developed YazevBattleTank 2: Metaller's Revenge************)
(*The game consists of one level - "Enemy City"; ("it must die");
and YazevBattleTank must destroy it!!!!!!!!!!!!!!Yeah!!!Yeah!!!Yeah!!!!!!!!!!!*)
(*in the future I will create many versions of YazevBattleTank on this beautiful
game engine: new version of "Advanced Yazev2DEngine"*)
(*next: I'll add music to my game - to my World!!!*)
(******I developed the sound engine and add music to my game at 16.07.2006*****)
(*******************I have developed the game today!!! Yeah!!!*****************)

unit YazevTank1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OpenGL, DirectInput8, AppEvnts, ExtCtrls, MPlayer;

  type
    TTank = class
    w, h, xpos, ypos, zdeg : GLFloat;
    made : Bool;
    procedure Load_Tank(tank : PChar); dynamic; abstract; 
  end;

  type
    TGround = class
    list : Integer;
    xpos, ypos, zdeg : GLFloat;
    showing : Bool;
    constructor Create(pic : PChar; lnum : Integer; xp, yp, zdegree : GLFloat);
    destructor Annihilate;
    procedure Load_Texture(pic : PChar);
    procedure Draw;
  end;

  type
    TBuilding = class(TTank)
    number, listnum, life : Integer;
    destroy, remove, dremove : Bool;
    img1, img2 : PChar;
    constructor Create(house, dhouse : PChar; num, list, lifes : Integer;
                       wb, hb, xb, yb, zdegree : GLFloat; logical, rot : Bool);
    destructor Annihilate(i : Integer);
    procedure Draw;
    procedure Load_Texture(image : PChar);
    procedure Explosion;
  end;

  type
    TYazevBattleTank = class(TTank)
    YazevTank, life : Integer;
    CanShoot, up : Bool;
    lxpos, lypos : GLFloat;
    constructor Create(tank : PChar);
    destructor Annihilate;
    procedure Draw;
    procedure Fire;
    procedure Load_Tank(tank : PChar); override;
    procedure Explosion;
  end;

  type
    TBullet = class(TTank)
    bul : Integer;
    xdir, ydir : GLFloat;
    USSR : Bool;
    constructor Create(i : Integer; xp, yp, zd : GLFloat; RUS : Bool);
    destructor Annihilate;
    procedure Draw;
    procedure Build_Explode(i : Integer);
    procedure EnemyTank_Explode(i : Integer);
    procedure Build_Explode_Enemy(i : Integer);
    procedure YazevBattleTank_Explode;
    procedure Gun_Explode(i : Integer);
  end;

  type
    TExplosion = class(TTank)
    lxpos, lypos : GLFloat;
    number, victimnumber, victimkind : Integer;                                  // 0 - building
    constructor Create(num, victnum, victkind : Integer; ww, hh, x, y,           // 1 - EnemyTank
                                                            deg : GLFloat);
    destructor Annihilate(num : Integer);
    procedure Draw(num : Integer);
    procedure Load_Texture;
   private
    ThisSec, LastSec : DWord;
  end;

  type
    TEnemy = class(TTank)
    life, number, listnumber : Integer;
    active : Bool;
   private
    ThisSec, LastSec : DWord;
  end;

  type
    TEnemyTank = class(TEnemy)
     lxpos, lypos : GLFloat;
     move : Bool;
     constructor Create(tank : PChar; num, lnum, lifes : Integer; ww, hh, x, y,
                        deg : GLFloat);
     destructor Die(i : Integer);
     procedure Draw;
     procedure Load_Tank(tank : PChar); override;
     procedure Fire;
     procedure Explosion;
   end;

   type
     TGun = class(TEnemy)
      listnumber2, listnumber3 : Integer;
      remove, sremove, alive : Bool;
      turZdeg, cturZdeg, multiplier : GLFloat;
      constructor Create(base, gun : PChar; num, lifes : Integer; x, y, deg,
                         turdeg : GLFloat; move : Bool);
      destructor Die(i : Integer);
      procedure Draw;
      procedure Load_Tank(tank : PChar); override;
      procedure Fire;
      procedure Explosion;
    end;

   type
     TLife = class(TTank)
      number, listnumber, ckind : Integer;
     constructor Create(pic : PChar; ww, hh, xp, yp, zd : GLFloat;
                        num, kind : Integer);
     destructor Die(i : Integer);
     procedure Draw;
     procedure Load_Tank(tank : PChar); override;
     procedure Load_Tank2(tank : PChar); 
   end;

   type
     TYazevMenu = class(TLife)
      w2, h2, xpos2, ypos2, zdeg2  : GLFloat;
      num2, lnum2, menucontrol : Integer;
      constructor Create;
      destructor Die;
      procedure Draw;
//      procedure Load_Tank(tank : PChar); override;
  //    procedure Load_Tank2(tank : PChar); override;
   end;

type
  TYazevWar = class(TForm)
    YazevAE: TApplicationEvents;
    YazevTimer: TTimer;
    YazevTankCreator: TTimer;
    YazevBattleTankCreator: TTimer;
    YazevGameLoading: TTimer;
    YazevBattleTankVictory: TTimer;
    YazevBattleTankDie: TTimer;
    YazevDelay: TTimer;
    YazevCloseUp: TTimer;
    YazevMusicPlayer: TMediaPlayer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure YazevAEIdle(Sender: TObject; var Done: Boolean);
    procedure YazevAEActivate(Sender: TObject);
    procedure YazevAEDeactivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure YazevTimerTimer(Sender: TObject);
    procedure YazevTankCreatorTimer(Sender: TObject);
    procedure YazevBattleTankCreatorTimer(Sender: TObject);
    procedure YazevGameLoadingTimer(Sender: TObject);
    procedure YazevBattleTankVictoryTimer(Sender: TObject);
    procedure YazevBattleTankDieTimer(Sender: TObject);
    procedure YazevDelayTimer(Sender: TObject);
    procedure YazevCloseUpTimer(Sender: TObject);
    procedure YazevMusicPlayerNotify(Sender: TObject);
  private
    { Private declarations }
    DC : HDC;
    rc : HGLRC;
    DI : IDirectInput8;
    DID : IDirectInputDevice8;
    ActiveGL : Bool;
//    ThisSec, LastSec : DWord;
    TanksCount, m_num : Integer;
    GamePlay, Victory, menumode, text_out : BOOL;
    lf : LOGFONT;
    heFont, hOldFont : HFont;
    procedure Setup_OpenGL;
    procedure Setup_DirectControl;
    procedure Draw_World;
    procedure Check_Buttons;
    procedure Load_Bullet;
    procedure Create_World;
    procedure Destroy_World;
    procedure Create_Surface_for_Bullet;
    procedure Load_Game(pic : PChar);
    procedure Load(img : PChar);
    procedure Init_TextGL;
    procedure Output_TextGL;
    procedure Write_TextGL;
    procedure Music_StartUp(num : Integer);
  public
    { Public declarations }
       YazevBattleTankLifes : Integer;
    protected
    procedure Catch_Mouse(var Msg : TMessage); message WM_SetCursor;
  end;

  const
   GL_LETTERS = 1000;

   sp = 57.3;
   // YazevBattleTank
   ytankimg = 'YazevBattleTank2.bmp';

   // tank common
   tw = 0.15;
   th = 0.09;
   speed = 0.012;

   // bullet
   bw = 0.055;
   bh = 0.0125;
   cbul = 2;
//   bulimg = 'bullet2.bmp';

   // explosion
   expl = 4;

 // buildings

 // Tanks
    MaxTanks = 10;
 // EnemyTanks_Params
   tank_number : Array [0..MaxTanks - 1, 0..2] of Integer =
                                                 ((0, 9, 3), (1, 9, 3),
                                                  (2, 9, 3), (3, 9, 3),
                                                  (4, 9, 3), (5, 9, 3),
                                                  (6, 9, 3), (7, 9, 3),
                                                  (8, 9, 3), (9, 9, 3));

  tank_params : Array [0..MaxTanks - 1, 0..4] of GLFloat =
                                                ((tw, th, -0.12, 0.18, 90.0),
                                                 (tw, th, -0.12, 0.18, 90.0),
                                                 (tw, th, -0.12, 0.18, 90.0),
                                                 (tw, th, -0.12, 0.18, 90.0),
                                                 (tw, th, -0.12, 0.18, 90.0),
                                                 (tw, th, -0.12, 0.18, 90.0),
                                                 (tw, th, -0.12, 0.18, 90.0),
                                                 (tw, th, -0.12, 0.18, 90.0),
                                                 (tw, th, -0.12, 0.18, 90.0),
                                                 (tw, th, -0.12, 0.18, 90.0));

  tank_images : Array [0..MaxTanks - 1] of PChar =
                                        (('EnemyBattleTank.bmp'),
                                         ('EnemyBattleTank.bmp'),
                                         ('EnemyBattleTank.bmp'),
                                         ('EnemyBattleTank.bmp'),
                                         ('EnemyBattleTank.bmp'),
                                         ('EnemyBattleTank.bmp'),
                                         ('EnemyBattleTank.bmp'),
                                         ('EnemyBattleTank.bmp'),
                                         ('EnemyBattleTank.bmp'),
                                         ('EnemyBattleTank.bmp'));

  // guns
  MaxGuns = 5;

  DIO = 'DIO_We Rock.mp3';

  Alice = 'Alice Cooper_Years Ago.mp3';

var
  YazevWar: TYazevWar;
  YazevBattleTank : TYazevBattleTank = nil;
  bullet : Array of TBullet;
  MaxBullets : Integer = 0;
  buildings : Array of TBuilding;
  MaxBuildings, buil : Integer;
  town : TGround;
  explosion : Array of TExplosion;
  MaxExp : Integer = 0;
  Tanks : Array [0..MaxTanks - 1] of TEnemyTank;
  guns : Array [0..MaxGuns - 1] of TGun;
  blifes : Array of TLife;
  slifes : Array [0..9] of TLife;
  yimage : TLife;
  ymenu : TYazevMenu;

  delay : Bool = False;

//  xx, yy : GLFloat;

implementation

{$R *.DFM}

{ TYazevWar }

procedure TYazevWar.Setup_DirectControl;
begin
DirectInput8Create(hInstance, DirectInput_Version, IID_IDirectInput8, DI, nil);
DI.CreateDevice(GUID_SysKeyboard, DID, nil);
DID.SetDataFormat(c_dfDIKeyboard);
DID.SetCooperativeLevel(Handle, DISCL_FOREGROUND OR DISCL_EXCLUSIVE);
DID.Acquire;
end;

procedure TYazevWar.Setup_OpenGL;
var
pfd : TPixelFormatDescriptor;
zPixel : Integer;
begin
FillChar(pfd, SizeOf(pfd), 0);
pfd.dwFlags := PFD_DRAW_TO_WINDOW OR PFD_SUPPORT_OPENGL OR PFD_DOUBLEBUFFER;
pfd.cColorBits := 32;
zPixel := ChoosePixelFormat(DC, @pfd);
SetPixelFormat(DC, zPixel, @pfd);
end;

procedure TYazevWar.FormCreate(Sender: TObject);
begin
DC := GetDC(Handle);
Setup_OpenGL;
rc := wglCreateContext(DC);
wglMakeCurrent(DC, rc);
glClearColor(0.7, 0.5, 0.2, 1.0);
glEnable(GL_BLEND);
glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Setup_DirectControl;
WindowState := wsMaximized;
//*************
Init_TextGL;
menumode := False;
ymenu := TYazevMenu.Create;
text_out := False;
//Create_World;
GamePlay := False;
Load_Game('YazevBattleTank2GameLoading.bmp');
//*************
//
Randomize;
ActiveGL := True;

//xx := 0.0;
//yy := 0.0;
end;

procedure TYazevWar.FormDestroy(Sender: TObject);
begin
if Assigned(DID) then begin
DID.Unacquire;
DID := nil;
end;
if Assigned(DI) then DI := nil;
//***********************************************
DeleteObject(SelectObject(YazevWar.DC, hOldFont));
glDeleteLists(GL_LETTERS, 256);
// YazevBattleTank2_Label
if yimage <> nil then yimage.Die(0);
//
Destroy_World;
// ymemu
if ymenu <> nil then ymenu.Die;
//
wglMakeCurrent(0, 0);
wglDeleteContext(rc);
ReleaseDC(Handle, DC);
DeleteDC(DC);
end;

procedure TYazevWar.Draw_World;
var
ps : TPaintStruct;
i{, f} : Integer;
gunskilled, tankskilled : Integer;
begin
gunskilled := 0;
tankskilled := 0;
//ThisSec := GetTickCount;
BeginPaint(Handle, ps);
glClear(GL_COLOR_BUFFER_BIT);
//glPushMatrix;
//glTranslatef(-xx, -yy, 0.0); ~~~ ”ра!!! я гений!!! “аким образом можно легко передвигать экран вместе с главным персонажем(!!!), но в этой игре мне это не потребуетс€, а может и пригодитс€, так € хочу, чтобы действи€ происходили на одном экране, только мен€ть фон, ну, вообщем, посмотрю в процессе разработки! игродел язев ёрий. 18.05.2006.
//glPopMatrix;

// ground
if town <> nil then town.Draw;
// text
if text_out then Write_TextGL;
// YazevBattleTank2_Label
if yimage <> nil then yimage.Draw;
// big lifes
for i := Low(blifes) to High(blifes) do
if blifes[i] <> nil then blifes[i].Draw;
// small lifes
for i := Low(slifes) to High(slifes) do
if slifes[i] <> nil then slifes[i].Draw;

// buildings
for i := Low(buildings) to High(buildings) do
if buildings[i] <> nil then buildings[i].Draw;
// ~~~~~~~~~~~

// guns
for i := Low(guns) to High(guns) do
if guns[i] <> nil then begin
guns[i].Draw;
if not guns[i].alive then gunskilled := gunskilled + 1;
end;
//--------------------------------

// YazevBattleTank
if YazevBattleTank <> nil then YazevBattleTank.Draw;
//~~~~~~~~~~~~~~~~~~~~
for i := Low(Tanks) to High(Tanks) do
if (Tanks[i] <> nil) and (Tanks[i].active) then Tanks[i].Draw
else if (Tanks[i] = nil) {and (not Tanks[i].active)} then
 tankskilled := tankskilled + 1;
//~~~~~~~~~~~~~~~~~~~~
for i := Low(explosion) to High(explosion) do
if (explosion[i] <> nil) and (explosion[i].made) then explosion[i].Draw(i);
// bullets
//f := 0;

try
for i := Low(bullet) to High(bullet) do //begin
if (bullet[i] <> nil) and (bullet[i].made) then bullet[i].Draw;
except
//for f := Low(bullet) to High(bullet) do
//if bullet[f] <> nil then bullet[f].Annihilate
MaxBullets := 0;
SetLength(bullet, MaxBullets);
end;

{
if bullet[i] = nil then f := f + 1;
end;
}
if (ymenu <> nil) and (menumode) then ymenu.Draw;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SwapBuffers(DC);
EndPaint(Handle, ps);
{
if f - 1 = High(bullet) then begin
MaxBullets := 0;
SetLength(bullet, MaxBullets);
end;
}
//Caption := IntToStr(High(bullet))

// YazevBattleTank wins
if (not Victory) and (GamePlay) and (YazevBattleTankLifes > 0)
and (buildings[14] <> nil) and (buildings[14].destroy)
and (buildings[16] <> nil) and (buildings[16].destroy)
and (tankskilled = MaxTanks) and (gunskilled = MaxGuns) then begin
YazevBattleTankVictory.Enabled := True;
//Caption := IntToStr(tankskilled) + '   ' + IntToStr(gunskilled);
end;
//Caption := IntToStr(tankskilled) + '   ' + IntToStr(gunskilled);
end;

procedure TYazevWar.YazevAEIdle(Sender: TObject; var Done: Boolean);
begin
if ActiveGL then begin
Draw_World;
if GamePlay then Check_Buttons;
end;
Done := False;
end;

procedure TYazevWar.YazevAEActivate(Sender: TObject);
begin
ActiveGL := True
end;

procedure TYazevWar.YazevAEDeactivate(Sender: TObject);
begin
ActiveGL := False
end;

procedure TYazevWar.FormResize(Sender: TObject);
begin
glViewPort(0, 0, ClientWidth, ClientHeight);
glLoadIdentity;
gluOrtho2D(-1.0, 1.0, -1.0, 1.0);
InvalidateRect(Handle, nil, False);
end;

procedure TYazevWar.Check_Buttons;
const
trotate = 4.5;
var
itog : HResult;
buts : Array [0..255] of Byte;
dir : Bool;
begin
dir := False;
ZeroMemory(@buts, SizeOf(buts));
itog := DID.GetDeviceState(SizeOf(buts), @buts);
if Failed(itog) then begin
itog := DID.Acquire;
while itog = DIERR_INPUTLOST do itog := DID.Acquire;
end;
if (buts [DIK_ESCAPE] and $80 <> 0) and (not delay) and (not menumode) then
begin
//Close;
menumode := True;
delay := True;
YazevDelay.Enabled := True;
//Exit;
end;
if (YazevBattleTank <> nil) and (not menumode) then begin
if (((buts [DIK_UP]) OR (buts [DIK_W])) AND $80 <> 0) then begin
YazevBattleTank.lxpos := YazevBattleTank.xpos;
YazevBattleTank.lypos := YazevBattleTank.ypos;
YazevBattleTank.up := True;
YazevBattleTank.xpos := YazevBattleTank.xpos - cos(YazevBattleTank.zdeg / sp) * speed;
YazevBattleTank.ypos := YazevBattleTank.ypos + sin(YazevBattleTank.zdeg / sp) * speed;
//xx := YazevBattleTank.xpos - cos(YazevBattleTank.zdeg / sp) * speed;
//yy := YazevBattleTank.ypos + sin(YazevBattleTank.zdeg / sp) * speed; см. комментарии в методе Draw_World
dir := True;
//Exit;
end;
if (((buts [DIK_DOWN]) OR (buts [DIK_S])) AND $80 <> 0) and (not(dir)) then begin
YazevBattleTank.lxpos := YazevBattleTank.xpos;
YazevBattleTank.lypos := YazevBattleTank.ypos;
YazevBattleTank.up := False;
YazevBattleTank.xpos := YazevBattleTank.xpos + cos(YazevBattleTank.zdeg / sp) * speed / 2;
YazevBattleTank.ypos := YazevBattleTank.ypos - sin(YazevBattleTank.zdeg / sp) * speed / 2;
//Exit;
end;
if (((buts [DIK_LEFT]) OR (buts [DIK_A])) AND $80 <> 0) then begin
YazevBattleTank.zdeg := YazevBattleTank.zdeg - trotate;
if YazevBattleTank.zdeg < 0 then YazevBattleTank.zdeg := 360;
//Exit;
end;
if (((buts [DIK_RIGHT]) OR (buts [DIK_D])) AND $80 <> 0) then begin
YazevBattleTank.zdeg := YazevBattleTank.zdeg + trotate;
if YazevBattleTank.zdeg > 360 then YazevBattleTank.zdeg := 0;
//Exit;
end;
if (buts [DIK_SPACE] AND $80 <> 0) and (YazevBattleTank.CanShoot) then begin
YazevBattleTank.Fire;
//Exit;
end;
end else

if (menumode) {and ((YazevBattleTank = nil) or (YazevBattleTank <> nil))} then
begin

if (buts [DIK_ESCAPE] and $80 <> 0) and (not delay) then begin
//Close;
menumode := False;
delay := True;
YazevDelay.Enabled := True;
//Exit;
end;

if (((buts [DIK_UP]) OR (buts [DIK_W])) AND $80 <> 0) and (not delay) then begin
if ymenu.menucontrol = 2 then begin
ymenu.ypos2 := -0.12;
ymenu.menucontrol := 1;
end else if ymenu.menucontrol = 1 then begin
ymenu.ypos2 := 0.0;
ymenu.menucontrol := 0;
end else if ymenu.menucontrol = 0 then begin
ymenu.ypos2 := -0.24;
ymenu.menucontrol := 2;
end;
delay := True;
YazevDelay.Enabled := True;
end;

if (((buts [DIK_DOWN]) OR (buts [DIK_S])) AND $80 <> 0) and (not delay) then begin
if ymenu.menucontrol = 0 then begin
ymenu.ypos2 := -0.12;
ymenu.menucontrol := 1;
end else if ymenu.menucontrol = 1 then begin
ymenu.ypos2 := -0.24;
ymenu.menucontrol := 2;
end else if ymenu.menucontrol = 2 then begin
ymenu.ypos2 := 0.0;
ymenu.menucontrol := 0;
end;
delay := True;
YazevDelay.Enabled := True;
end;

if (buts [DIK_RETURN] AND $80 <> 0) and (not delay) then begin
if ymenu.menucontrol = 0 then menumode := False else
if ymenu.menucontrol = 2 then begin
{
Close;
Exit;
}
Destroy_World;
//if yimage <> nil then yimage.Die(0);
GamePlay := False;
Load('YazevBattleTank2Thanks.bmp');
YazevCloseUp.Enabled := True;
end else
if ymenu.menucontrol = 1 then begin
Destroy_World;
if yimage <> nil then yimage.Die(0);
Load_Game('YazevBattleTank2GameLoading.bmp');
end;

delay := True;
YazevDelay.Enabled := True;
end;
end;
if (not Victory) and (YazevMusicPlayer.Enabled) then begin
if (buts [DIK_1] and $80 <> 0) then Music_StartUp(0);
if (buts [DIK_2] and $80 <> 0) then Music_StartUp(1);
if (buts [DIK_3] and $80 <> 0) then Music_StartUp(2);
end;
//Caption := FloatToStr(ymenu.ypos2)
end;

procedure TYazevBattleTank.Load_Tank(tank: PChar);
var
i, j : Integer;
bit : TBitmap;
pix : Array [0..63, 0..127, 0..3] of GLUByte;
begin
bit := TBitmap.Create;
bit.LoadFromFile(tank);
for i := 0 to 63 do
for j := 0 to 127 do begin
pix[i, j, 0] := GetRValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 1] := GetGValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 2] := GetBValue(bit.Canvas.Pixels[i, j]);
if (pix[i, j, 0] > 150) and (pix[i, j, 1] > 150) and (pix[i, j, 2] > 150) then
pix[i, j, 3] := 0
else
pix[i, j, 3] := 255
end;
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 128, 64, 0, GL_RGBA, GL_UNSIGNED_BYTE, @pix);
glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
glEnable(GL_TEXTURE_2D);
end;

procedure TYazevWar.Create_World;
const
// buildings
MaxBuilds = 17;
   // first - for list number
   // second - for life count
  buildlistnumber : Array [0..MaxBuilds - 1, 0..1] of Integer =
                                              ((3, 1), (3, 1), (3, 1), (3, 1),
                                               (3, 1), (5, 2), (5, 2), (6, 3),
                                               (6, 3), (6, 3), (3, 1), (6, 3),
                                               (3, 1), (3, 1), (7, 7), (3, 1),
                                               (8, 15));

  // "width", "height", "X", "Y", "degree"
  build_params : Array [0..MaxBuilds - 1, 0..4] of GLFloat =
                                                ((0.3, 0.2, -0.84, 0.88, 0.0),
                                                 (0.3, 0.2, -0.52, 0.88, 0.0),
                                                 (0.3, 0.2, 0.02, 0.88, 0.0),
                                                 (0.3, 0.2, 0.32, 0.88, 0.0),
                                                 (0.3, 0.2, 0.82, 0.88, 0.0),
                                                 (0.5, 0.2, -0.85, 0.5, 90.0),
                                                 (0.5, 0.2, -0.85, -0.07, 90.0),
                                                 (0.4, 0.25, -0.76, -0.7, 0.0),
                                                 (0.4, 0.25, -0.28, -0.7, 0.0),
                                                 (0.4, 0.25, 0.2, -0.7, 0.0),
                                                 (0.3, 0.2, 0.8, 0.33, 90.0),
                                                 (0.4, 0.25, 0.83, -0.3, -90.0),
                                                 (0.3, 0.2, 0.8, 0.63, 90.0),
                                                 (0.3, 0.2, 0.8, -0.65, 90.0),
                                                 (0.5, 0.3, -0.35, 0.2, 90.0),
                                                 (0.3, 0.2, -0.35, -0.2, 0.0),
                                                 (0.8, 0.4, 0.25, 0.075, 90.0));

  // first logical constant for "build move after death"
  // second  logical constant for "build rotates after create"
  build_logical : Array [0..MaxBuilds - 1, 0..1] of Bool =
  ((False, False), (False, False), (False, False), (False, False),
  (False, False), (False, True), (False, True), (False, False), (False, False),
  (False, False), (False, True), (False, True), (False, True), (False, True),
  (True, True), (True, False), (True, True));

  // first image for building life
  // second image for building death
  build_images : Array [0..MaxBuilds - 1, 0..1] of PChar =
   (('house01.bmp', 'dhouse01.bmp'), ('house01.bmp', 'dhouse01.bmp'),
    ('house01.bmp', 'dhouse01.bmp'), ('house01.bmp', 'dhouse01.bmp'),
    ('house01.bmp', 'dhouse01.bmp'), ('house02.bmp', 'dhouse01.bmp'),
    ('house02.bmp', 'dhouse01.bmp'), ('house03.bmp', 'dhouse01.bmp'),
    ('house03.bmp', 'dhouse01.bmp'), ('house03.bmp', 'dhouse01.bmp'),
    ('house01.bmp', 'dhouse01.bmp'), ('house03.bmp', 'dhouse01.bmp'),
    ('house01.bmp', 'dhouse01.bmp'), ('house01.bmp', 'dhouse01.bmp'),
    ('house04.bmp', 'dhouse01.bmp'), ('house01.bmp', 'dhouse01.bmp'),
    ('house05.bmp', 'dhouse01.bmp'));
                                                                             {
  build_img_d : Array [0..MaxBuilds - 1] of PChar = (('dhouse01.bmp'), ('dhouse01.bmp'),
                                         ('dhouse01.bmp'), ('dhouse01.bmp'),
                                         ('dhouse01.bmp'), ('dhouse01.bmp'));
                                                                              }
                                                                              {
  build_move_after_death : Array [0..5] of Bool = ((False), (False), (False),
                                                   (False), (False), (True));
                                                                              }
{
  tank_number : Array [0..1, 0..2] of Integer = ((0, 9, 3), (1, 9, 3));

  tank_params : Array [0..1, 0..4] of GLFloat = ((tw, th, 0.6, 0.6, 0.0),
                                                 (tw, th, -0.6, -0.0, 0.0));

  tank_images : Array [0..1] of PChar = (('EnemyBattleTank.bmp'),
                                         ('EnemyBattleTank.bmp'));
 }

guns_params : Array [0..MaxGuns - 1, 0..3] of GLFloat =
                         ((-0.89, -0.45, 0.0, 180.0), (-0.25, 0.91, 0.0, -90.0),
                          (0.85, 0.05, 0.0, 0.0), (0.575, 0.91, 0.0, -90.0),
                          (0.565, -0.7, 0.0, 90.0));

guns_log_par : Array [0..MaxGuns - 1] of Bool = ((False), (False), (False),
                                                 (False), (False));

//guns_images : Array [0..MaxGuns - 1, 0..1] of PChar

blifes_pos : Array [0..2, 0..1] of GLFloat = ((-0.95, -0.92), (-0.85, -0.92),
                                              (-0.75, -0.92));

var
i : Integer;
begin
Victory := False;
// Ground
town := TGround.Create('Ground00.bmp', 101, 0, 0, 90.0);
// YazevBattleTank2_Label
yimage := TLife.Create('YazevBattleTank2_Label.bmp', 1.1, 0.12, 0.425, -0.92, 180.0, 0, 0);
// big lifes
SetLength(blifes, 3);
for i := Low(blifes) to High(blifes) do
blifes[i] := TLife.Create('YazevBattleTank2.bmp', tw, th, blifes_pos[i, 0], blifes_pos[i, 1], 90.0, i, 2);

// small lifes are created by YazevBattleTank constructor

YazevTankCreator.Interval := 2000;
YazevTankCreator.Enabled := True;
// YazevBattleTank
YazevBattleTank := TYazevBattleTank.Create(ytankimg);
// bullet
//bullet := TBullet.Create(bulimg, 2);
Create_Surface_for_Bullet;
buil := 0;
MaxBuildings := High(buildlistnumber) + 1;
SetLength(buildings, MaxBuildings);
for i := Low(buildings) to High(buildings) do
buildings[i] := TBuilding.Create(build_images[i, 0], build_images[i, 1], i,
 buildlistnumber[i, 0], buildlistnumber[i, 1], build_params[i, 0],
 build_params[i, 1], build_params[i, 2], build_params[i, 3], build_params[i, 4],
 build_logical[i, 0], build_logical[i, 1]);
 {
for i := Low(Tanks) to High(Tanks) do
Tanks[i] := TEnemyTank.Create(tank_images[i], tank_number[i, 0],
 tank_number[i, 1], tank_number[i, 2], tank_params[i, 0], tank_params[i, 1],
 tank_params[i, 2], tank_params[i, 3], tank_params[i, 4]);
     }
for i := Low(guns) to High(guns) do
guns[i] := TGun.Create('gun_base.bmp', 'gun_turret.bmp', i, 5,
   guns_params[i, 0], guns_params[i, 1], guns_params[i, 2],
   guns_params[i, 3], guns_log_par[i]);

//LastSec := GetTickCount;
TanksCount := 0;
YazevBattleTankLifes := 3;

GamePlay := True;
text_out := True;

m_num := 0;
// play music
YazevMusicPlayer.Enabled := True;
Music_StartUp(m_num);
end;

procedure TYazevWar.Destroy_World;
var
i : Integer;
begin
{
if Assigned(DID) then begin
DID.Unacquire;
DID := nil;
end;
if Assigned(DI) then DI := nil;
}
{
//for i := Low(explosion) to High(explosion) do begin
explosion.Annihilate(i);
explosion.Free;
//end;
 }

if YazevMusicPlayer.Enabled then begin
YazevMusicPlayer.Stop;
YazevMusicPlayer.Enabled := False;
end;

menumode := False;
//GamePlay := False;
Victory := False;
text_out := False;

ymenu.menucontrol := 0;
// big lifes
for i := Low(blifes) to High(blifes) do
if blifes[i] <> nil then blifes[i].Die(i);
// small lifes
for i := Low(slifes) to High(slifes) do
if slifes[i] <> nil then slifes[i].Die(i);
// bullet
glDeleteLists(expl, 1);

if YazevBattleTank <> nil then YazevBattleTank.Annihilate;
//YazevBattleTank.Free;

glDeleteLists(cbul, 1);

for i := Low(Tanks) to High(Tanks) do
if Tanks[i] <> nil then begin
Tanks[i].Die(i);
Tanks[i].Free;
end;

for i := Low(guns) to High(guns) do
if guns[i] <> nil then begin
guns[i].Die(i);
guns[i].Free;
end;

for i := Low(buildings) to High(buildings) do
if buildings[i] <> nil then begin
buildings[i].Annihilate(i);
buildings[i].Free;
end;

if town <> nil then town.Annihilate;

// timers
YazevTimer.Enabled := False;
YazevTankCreator.Enabled := False;
YazevBattleTankCreator.Enabled := False;
YazevGameLoading.Enabled := False;
YazevBattleTankVictory.Enabled := False;
YazevBattleTankDie.Enabled := False;
YazevDelay.Enabled := False;
end;

procedure TYazevWar.Create_Surface_for_Bullet;
var
x, y : GLFloat;
begin
x := 0.0 - bw / 2;
y := 0.0 - bh / 2;
glPushMatrix;
glNewList(cbul, GL_COMPILE);
Load_Bullet;
glBegin(GL_QUADS);
glColor3f(1.0, 1.0, 1.0);
glTexCoord2f(0.0, 0.0);
glVertex3f(x, y, 0);
glTexCoord2f(1.0, 0.0);
glVertex3f(x + bw, y, 0.0);
glTexCoord2f(1.0, 1.0);
glVertex3f(x + bw, y + bh, 0.0);
glTexCoord2f(0.0, 1.0);
glVertex3f(x, y + bh, 0.0);
glEnd;
glEndList;
glPopMatrix;
end;

procedure TYazevWar.Catch_Mouse(var Msg: TMessage);
begin
SetCursor(0);
end;

procedure TYazevWar.Load_Game(pic: PChar);
begin
town := TGround.Create(pic, 101, 0, 0, 90.0);
SetLength(blifes, 20);
YazevGameLoading.Enabled := True;
end;

procedure TYazevWar.Load(img : PChar);
begin
town := TGround.Create(img, 101, 0, 0, 90.0);
end;

procedure TYazevWar.Write_TextGL;
var
s : String;
begin
glColor3f(1.0, 0.0, 0.0);
glListBase(GL_LETTERS);
s := 'YazevBattleTank 2: Metaller''s Revenge';
glPushMatrix;
glTranslatef(-0.675, 0.6, 0.0);
glScalef(0.07, 0.07, 0.07);
glCallLists(Length(s), GL_UNSIGNED_BYTE, PChar(s));
glPopMatrix;
s := 'developed in YazevSoft by Yazev Yuriy';
glPushMatrix;
glTranslatef(-0.675, -0.44, 0.0);
glScalef(0.07, 0.07, 0.07);
glCallLists(Length(s), GL_UNSIGNED_BYTE, PChar(s));
glPopMatrix;
end;

procedure TYazevWar.Music_StartUp(num : Integer);
const
  // music
  MaxMusic = 3;

  music_col : Array [0..MaxMusic - 1] of String =
                                     (('Motorhead_01 Motorhead.mp3'),
                                      ('Motorhead_02 Ace Of Spades.mp3'),
                                      ('Motorhead_03 Overkill.mp3'));
begin
if num > MaxMusic - 1 then begin
num := 0;
m_num := 0;
end;
with YazevMusicPlayer do begin
FileName := music_col[num];
Open;
Play;
end;
end;

{ TYazevBattleTank }

constructor TYazevBattleTank.Create(tank: PChar);
const
xp = 0.57;
yp = 0.05;
divisor = 3;
slifes_pos : Array [0..9, 0..1] of GLFloat =
((-0.6, -0.885), (-0.55, -0.885), (-0.5, -0.885), (-0.45, -0.885), (-0.4, -0.885),
 (-0.6, -0.955), (-0.55, -0.955), (-0.5, -0.955), (-0.45, -0.955), (-0.4, -0.955));
var
x, y : GLFloat;
i, o : Integer;
begin
// small lifes
for i := Low(slifes) to High(slifes) do
slifes[i] := TLife.Create('YazevBattleTank2.bmp', 0, 0, slifes_pos[i, 0], slifes_pos[i, 1], 90.0, i, 1);

made := True;
CanShoot := True;
up := True;
YazevTank := 1;
x := 0.0 - tw / 2;
y := 0.0 - th / 2;
glPushMatrix;
glNewList(YazevTank, GL_COMPILE);
Load_Tank(tank);
glBegin(GL_QUADS);
glColor3f(1.0, 1.0, 1.0);
glTexCoord2f(0.0, 0.0);
glVertex3f(x, y, 0);
glTexCoord2f(1.0, 0.0);
glVertex3f(x + tw, y, 0.0);
glTexCoord2f(1.0, 1.0);
glVertex3f(x + tw, y + th, 0.0);
glTexCoord2f(0.0, 1.0);
glVertex3f(x, y + th, 0.0);
glEnd;
glEndList;
glPopMatrix;
w := tw;
h := th;
//w := tw;
xpos := xp;
ypos := yp;
zdeg := 90.0;
lxpos := 0.0;
lypos := 0.0;
life := 10;
//*****************************************************************************
// LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!!
o := random(200);
for i := Low(Tanks) to High(Tanks) do
if (Tanks[i] <> nil) and
(xpos + w / 2 > Tanks[i].xpos - Tanks[i].w / 2) and (xpos - w / 2 < Tanks[i].xpos + Tanks[i].w / 2) and
(ypos + w / 2 >= Tanks[i].ypos - Tanks[i].h / 2) and (ypos - w / 2 <= Tanks[i].ypos + Tanks[i].h / 2) then
while (xpos + w / 2 > Tanks[i].xpos - Tanks[i].w / 2) and (xpos - w / 2 < Tanks[i].xpos + Tanks[i].w / 2) and
(ypos + w / 2 >= Tanks[i].ypos - Tanks[i].h / 2) and (ypos - w / 2 <= Tanks[i].ypos + Tanks[i].h / 2) do
if o > 100 then begin
if not (ypos >= 0.6) then ypos := Tanks[i].ypos + w else
if not (ypos <= -0.45) then ypos := Tanks[i].ypos - w;
lxpos := xpos;
lypos := ypos;
end else begin
if not (ypos <= -0.45) then ypos := Tanks[i].ypos - w else
if not (ypos >= 0.6) then ypos := Tanks[i].ypos + w;
lxpos := xpos;
lypos := ypos;
end;
// LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!!
//*****************************************************************************
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//*****************************************************************************
// LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!!
for i := Low(bullet) to High(bullet) do
if (bullet[i] <> nil) and (bullet[i].made) then
if (xpos + w / 2 >= bullet[i].xpos - bullet[i].w / 2) and (xpos - w / 2 <= bullet[i].xpos + bullet[i].w / 2) and
(ypos + w / 2 >= bullet[i].ypos - bullet[i].w / 2) and (ypos - w / 2 <= bullet[i].ypos + bullet[i].w / 2) then bullet[i].Annihilate;
// LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!!
//*****************************************************************************
end;

destructor TYazevBattleTank.Annihilate;
begin
glDeleteLists(YazevTank, 1);
YazevBattleTank := nil;
YazevBattleTank.Free;
end;

procedure TYazevBattleTank.Draw; // здесь € впервые реализовал "умный" механизм
const                            // нахождени€ и обработки столкновений,
divisor = 3;                     // который сам придумал и разработал
var                              //                                   язев ёрий
i : Integer;
begin
for i := Low(buildings) to High(buildings) do
if (buildings[i] <> nil) and (not(buildings[i].remove)) then begin
if (xpos + w / 2 > buildings[i].xpos - buildings[i].w / 2) and (xpos - w / 2 < buildings[i].xpos + buildings[i].w / 2) and
(ypos + w / 2 >= buildings[i].ypos - buildings[i].h / 2) and (ypos - w / 2 <= buildings[i].ypos + buildings[i].h / 2) then begin
//xpos := lxpos; // √ениально!!!
ypos := lypos;
if up then xpos := xpos + (cos(zdeg / sp) * speed) / divisor else // _+_ --- √ениально!!!
xpos := xpos - (cos(zdeg / sp) * speed) / divisor
end;
if (xpos + w / 2 > buildings[i].xpos - buildings[i].w / 2) and (xpos - w / 2 < buildings[i].xpos + buildings[i].w / 2) and
(ypos + w / 2 >= buildings[i].ypos - buildings[i].h / 2) and (ypos - w / 2 <= buildings[i].ypos + buildings[i].h / 2) then begin
xpos := lxpos;
//ypos := lypos;
if up then ypos := ypos + (sin(zdeg / sp) * speed) / divisor else
ypos := ypos - (sin(zdeg / sp) * speed) / divisor
end;
if (xpos + w / 2 > buildings[i].xpos - buildings[i].w / 2) and (xpos - w / 2 < buildings[i].xpos + buildings[i].w / 2) and
(ypos + w / 2 >= buildings[i].ypos - buildings[i].h / 2) and (ypos - w / 2 <= buildings[i].ypos + buildings[i].h / 2) then begin
xpos := lxpos;
ypos := lypos;
end;
end;                            // √ениально!!! я гений!!! язев ёрий - гений!!!

for i := Low(guns) to High(guns) do
if (guns[i] <> nil) and (not(guns[i].remove)) then begin
if (xpos + w / 2 > guns[i].xpos - guns[i].w / 2) and (xpos - w / 2 < guns[i].xpos + guns[i].w / 2) and
(ypos + w / 2 >= guns[i].ypos - guns[i].h / 2) and (ypos - w / 2 <= guns[i].ypos + guns[i].h / 2) then begin
//xpos := lxpos; // √ениально!!!
ypos := lypos;
if up then xpos := xpos + (cos(zdeg / sp) * speed) / divisor else // _+_ --- √ениально!!!
xpos := xpos - (cos(zdeg / sp) * speed) / divisor
end;
if (xpos + w / 2 > guns[i].xpos - guns[i].w / 2) and (xpos - w / 2 < guns[i].xpos + guns[i].w / 2) and
(ypos + w / 2 >= guns[i].ypos - guns[i].h / 2) and (ypos - w / 2 <= guns[i].ypos + guns[i].h / 2) then begin
xpos := lxpos;
//ypos := lypos;
if up then ypos := ypos + (sin(zdeg / sp) * speed) / divisor else
ypos := ypos - (sin(zdeg / sp) * speed) / divisor
end;
if (xpos + w / 2 > guns[i].xpos - guns[i].w / 2) and (xpos - w / 2 < guns[i].xpos + guns[i].w / 2) and
(ypos + w / 2 >= guns[i].ypos - guns[i].h / 2) and (ypos - w / 2 <= guns[i].ypos + guns[i].h / 2) then begin
xpos := lxpos;
ypos := lypos;
end;
end;

for i := Low(Tanks) to High(Tanks) do
if (Tanks[i] <> nil) {and (not(Tanks[i].remove))} then begin
if (xpos + w / 2 > Tanks[i].xpos - Tanks[i].w / 2) and (xpos - w / 2 < Tanks[i].xpos + Tanks[i].w / 2) and
(ypos + w / 2 >= Tanks[i].ypos - Tanks[i].h / 2) and (ypos - w / 2 <= Tanks[i].ypos + Tanks[i].h / 2) then begin
//xpos := lxpos; // √ениально!!!
ypos := lypos;
if up then xpos := xpos + (cos(zdeg / sp) * speed) / divisor else // _+_ --- √ениально!!!
xpos := xpos - (cos(zdeg / sp) * speed) / divisor
end;
if (xpos + w / 2 > Tanks[i].xpos - Tanks[i].w / 2) and (xpos - w / 2 < Tanks[i].xpos + Tanks[i].w / 2) and
(ypos + w / 2 >= Tanks[i].ypos - Tanks[i].h / 2) and (ypos - w / 2 <= Tanks[i].ypos + Tanks[i].h / 2) then begin
xpos := lxpos;
//ypos := lypos;
if up then ypos := ypos + (sin(zdeg / sp) * speed) / divisor else
ypos := ypos - (sin(zdeg / sp) * speed) / divisor
end;
if (xpos + w / 2 > Tanks[i].xpos - Tanks[i].w / 2) and (xpos - w / 2 < Tanks[i].xpos + Tanks[i].w / 2) and
(ypos + w / 2 >= Tanks[i].ypos - Tanks[i].h / 2) and (ypos - w / 2 <= Tanks[i].ypos + Tanks[i].h / 2) then begin
xpos := lxpos;
ypos := lypos;
end;
end;

glPushMatrix;
glTranslatef(xpos, ypos, 0.0);
glRotatef(-zdeg, 0.0, 0.0, 1.0);
glCallList(YazevTank);
glPopMatrix;
end;

procedure TYazevBattleTank.Explosion;
var
i : Integer;
begin
YazevBattleTank.Annihilate;
//YazevBattleTank.Free;
YazevWar.YazevBattleTankLifes := YazevWar.YazevBattleTankLifes - 1;

for i := High(blifes) downto Low(blifes) do
if blifes[i] <> nil then begin
blifes[i].Die(i);
Break;
end;

if YazevWar.YazevBattleTankLifes > 0 then
YazevWar.YazevBattleTankCreator.Enabled := True
else YazevWar.YazevBattleTankDie.Enabled := True
end;

{ TBullet }

destructor TBullet.Annihilate;
var
i : Integer;
b : Bool;
begin
b := False;
made := False;
bullet[bul] := nil;
bullet[bul].Free;
for i := Low(bullet) to High(bullet) do
if bullet[i] <> nil then begin
b := True;
Break;
end;
if not b then begin
MaxBullets := 0;
SetLength(bullet, MaxBullets);
end;
end;

constructor TBullet.Create(i: Integer; xp, yp, zd : GLFloat; RUS : Bool);
begin
//bullet
made := True;
bul := i;
w := bw;
h := bh;

USSR := RUS;

xpos := xp;
ypos := yp;
zdeg := zd;
end;

procedure TBullet.Draw;
var
i : Integer;
begin
glPushMatrix;
if not YazevWar.menumode then begin
xpos := xpos - xdir*2;
ypos := ypos + ydir*2;
end;
glTranslatef(xpos, ypos, 0.0);
glRotatef(-zdeg, 0.0, 0.0, 1.0);
if (xpos > 1.0) or (xpos < -1.0) or (ypos > 1.0) or (ypos < -0.85) then begin
Annihilate;
//bullet[bul].Free;
glPopMatrix;
exit;
end;
glCallList(cbul);
glPopMatrix;
//                  if (ypos > 0.5) then Explode;
if USSR then begin
for i := Low(buildings) to High(buildings) do
if (buildings[i] <> nil) and (not buildings[i].destroy) then
if (xpos + w / 2 >= buildings[i].xpos - buildings[i].w / 2) and (xpos - w / 2 <= buildings[i].xpos + buildings[i].w / 2) and
(ypos + h / 2 >= buildings[i].ypos - buildings[i].h / 2) and (ypos - h / 2 <= buildings[i].ypos + buildings[i].h / 2) then Build_Explode(i);
//end;
//
for i := Low(Tanks) to High(Tanks) do
if (Tanks[i] <> nil) and (Tanks[i].active) then
if (xpos + w / 2 >= tanks[i].xpos - tanks[i].w / 2) and (xpos - w / 2 <= tanks[i].xpos + tanks[i].w / 2) and
(ypos + h / 2 >= tanks[i].ypos - tanks[i].h / 2) and (ypos - h / 2 <= tanks[i].ypos + tanks[i].h / 2) then EnemyTank_Explode(i);

for i := Low(guns) to High(guns) do
if (guns[i] <> nil) and (guns[i].active) and (guns[i].alive) then
if (xpos + w / 2 >= guns[i].xpos - guns[i].w / 2) and (xpos - w / 2 <= guns[i].xpos + guns[i].w / 2) and
(ypos + h / 2 >= guns[i].ypos - guns[i].h / 2) and (ypos - h / 2 <= guns[i].ypos + guns[i].h / 2) then Gun_Explode(i);

end else begin
for i := Low(buildings) to High(buildings) do
if (buildings[i] <> nil) and (not buildings[i].destroy) then
if (xpos + w / 2 >= buildings[i].xpos - buildings[i].w / 2) and (xpos - w / 2 <= buildings[i].xpos + buildings[i].w / 2) and
(ypos + h / 2 >= buildings[i].ypos - buildings[i].h / 2) and (ypos - h / 2 <= buildings[i].ypos + buildings[i].h / 2) then Build_Explode_Enemy(i);

if (YazevBattleTank <> nil) {and (Tanks[i].active)} then
if (xpos + w / 2 >= YazevBattleTank.xpos - YazevBattleTank.w / 2) and (xpos - w / 2 <= YazevBattleTank.xpos + YazevBattleTank.w / 2) and
(ypos + h / 2 >= YazevBattleTank.ypos - YazevBattleTank.h / 2) and (ypos - h / 2 <= YazevBattleTank.ypos + YazevBattleTank.h / 2) then YazevBattleTank_Explode;
end;
//YazevWar.Caption := IntToStr(High(bullet)) + '       ' + IntToStr(MaxBullets) ~~~ Look Out!!!
end;

procedure TYazevWar.Load_Bullet;
var
i, j : Integer;
b : TBitmap;
pix : Array [0..15, 0..31, 0..3] of GLUbyte;
begin
b := TBitmap.Create;
b.LoadFromFile('bullet2.bmp');
for i := 0 to 15 do
for j := 0 to 31 do begin
pix[i, j, 0] := GetRValue(b.Canvas.Pixels[i, j]);
pix[i, j, 1] := GetGValue(b.Canvas.Pixels[i, j]);
pix[i, j, 2] := GetBValue(b.Canvas.Pixels[i, j]);
if (pix[i, j, 0] > 200) and (pix[i, j, 1] > 200) and (pix[i, j, 2] > 200) then
pix[i, j, 3] := 0 else pix[i, j, 3] := 255;
end;
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 16, 32, 0, GL_RGBA, GL_UNSIGNED_BYTE, @pix);
glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
glEnable(GL_TEXTURE_2D);
end;

procedure TYazevWar.YazevTimerTimer(Sender: TObject);
begin
YazevBattleTank.CanShoot := True;
YazevTimer.Enabled := False;
end;

procedure TYazevBattleTank.Fire;
const
factor = 9;
begin
MaxBullets := MaxBullets + 1;
SetLength(bullet, MaxBullets);
bullet[MaxBullets - 1] := TBullet.Create(MaxBullets - 1, xpos, ypos, zdeg, True);
if up then begin
bullet[MaxBullets - 1].xdir := cos(zdeg / sp) * speed;
bullet[MaxBullets - 1].ydir := sin(zdeg / sp) * speed;
end else begin
bullet[MaxBullets - 1].xdir := cos(zdeg / sp) * speed;
bullet[MaxBullets - 1].ydir := sin(zdeg / sp) * speed;
end;
glPushMatrix;
with bullet[MaxBullets - 1] do begin
xpos := xpos - xdir * factor;
ypos := ypos + ydir * factor;
glTranslatef(xpos, ypos, 0.0);
glRotatef(-zdeg, 0.0, 0.0, 1.0);
end;
glPopMatrix;
CanShoot := False;
YazevWar.YazevTimer.Enabled := True;
end;

procedure TBullet.Build_Explode(i : Integer);
begin
MaxExp := MaxExp + 1;
SetLength(Explosion, MaxExp);
//explosion[MaxExp - 1] := TExplosion.Create(MaxExp - 1, 0.15, 0.14, xpos, ypos, 0.0);
explosion[MaxExp - 1] := TExplosion.Create(MaxExp - 1, i, 0, buildings[i].w, buildings[i].h, buildings[i].xpos, buildings[i].ypos, 0.0);
Annihilate;
//bullet[bul].Free;
end;

procedure TBullet.EnemyTank_Explode(i: Integer);
begin
MaxExp := MaxExp + 1;
SetLength(Explosion, MaxExp);
explosion[MaxExp - 1] := TExplosion.Create(MaxExp - 1, i, 1, Tanks[i].w, Tanks[i].h, Tanks[i].xpos, Tanks[i].ypos, 0.0);
//Tanks[i].active := False;
Annihilate;
//bullet[bul].Free;
end;

procedure TBullet.Build_Explode_Enemy(i: Integer);
begin
MaxExp := MaxExp + 1;
SetLength(Explosion, MaxExp);
//explosion[MaxExp - 1] := TExplosion.Create(MaxExp - 1, 0.15, 0.14, xpos, ypos, 0.0);
explosion[MaxExp - 1] := TExplosion.Create(MaxExp - 1, -1, -1, tw * 2, th * 2, xpos, ypos, 0.0);
Annihilate;
//bullet[bul].Free;
end;

procedure TBullet.YazevBattleTank_Explode;
begin
MaxExp := MaxExp + 1;
SetLength(Explosion, MaxExp);
explosion[MaxExp - 1] := TExplosion.Create(MaxExp - 1, -2, -2, YazevBattleTank.w, YazevBattleTank.h, YazevBattleTank.xpos, YazevBattleTank.ypos, 0.0);
//Tanks[i].active := False;
Annihilate;
//bullet[bul].Free;
end;

procedure TBullet.Gun_Explode(i: Integer);
begin
MaxExp := MaxExp + 1;
SetLength(Explosion, MaxExp);
explosion[MaxExp - 1] := TExplosion.Create(MaxExp - 1, i, 2, guns[i].w, guns[i].h, guns[i].xpos, guns[i].ypos, 0.0);
//Tanks[i].active := False;
Annihilate;
//bullet[bul].Free;
end;

{ TBuilding }

destructor TBuilding.Annihilate(i : Integer);
begin
if buil < i then begin
buil := i;
glDeleteLists(listnum, 1);
glDeleteLists(-listnum, 1);
end;
buildings[i] := nil;
end;

constructor TBuilding.Create(house, dhouse: PChar; num, list, lifes : Integer;
                             wb, hb, xb, yb, zdegree : GLFloat; logical, rot :
                             Bool);
var
j : Integer;
b : Bool;
x, y : GLFloat;
begin
b := False;
for j := Low(buildings) to High(buildings) do
if (buildings[j] <> nil) and (buildings[j].listnum = list) then begin
b := True;
break;
end;
if not b then begin
x := 0.0 - wb / 2;
y := 0.0 - hb / 2;
glPushMatrix;
glNewList(list, GL_COMPILE);
Load_Texture(house);
glBegin(GL_QUADS);
glColor3f(1.0, 1.0, 1.0);
glTexCoord2f(0.0, 0.0);
glVertex3f(x, y, 0);
glTexCoord2f(1.0, 0.0);
glVertex3f(x + wb, y, 0.0);
glTexCoord2f(1.0, 1.0);
glVertex3f(x + wb, y + hb, 0.0);
glTexCoord2f(0.0, 1.0);
glVertex3f(x, y + hb, 0.0);
glEnd;
glEndList;
glPopMatrix;
//
glPushMatrix;
glNewList(-list, GL_COMPILE);
Load_Texture(dhouse);
glBegin(GL_QUADS);
glColor3f(1.0, 1.0, 1.0);
glTexCoord2f(0.0, 0.0);
glVertex3f(x, y, 0);
glTexCoord2f(1.0, 0.0);
glVertex3f(x + wb, y, 0.0);
glTexCoord2f(1.0, 1.0);
glVertex3f(x + wb, y + hb, 0.0);
glTexCoord2f(0.0, 1.0);
glVertex3f(x, y + hb, 0.0);
glEnd;
glEndList;
glPopMatrix;
end;
number := num;
listnum := list;
img1 := house;
img2 := dhouse;
if not rot then begin
w := wb;
h := hb;
end else begin
w := hb;
h := wb;
end;
xpos := xb;
ypos := yb;
zdeg := zdegree;
destroy := False;
remove := False;
dremove := logical;
life := lifes;
made := True;
end;

procedure TBuilding.Draw;
begin
glPushMatrix;
//zdeg := zdeg + 0.1;
glTranslatef(xpos, ypos, 0.0);
glRotatef(-zdeg, 0.0, 0.0, 1.0);
if destroy then glCallList(-listnum) else glCallList(listnum);
glPopMatrix;
end;

procedure TBuilding.Explosion;
begin
destroy := True;
remove := dremove;
end;

procedure TBuilding.Load_Texture(image: PChar);
var
i, j : Integer;
bit : TBitmap;
pix : Array [0..127, 0..255, 0..3] of GLUByte;
begin
bit := TBitmap.Create;
bit.LoadFromFile(image);
for i := 0 to 127 do
for j := 0 to 255 do begin
pix[i, j, 0] := GetRValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 1] := GetGValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 2] := GetBValue(bit.Canvas.Pixels[i, j]);
if (pix[i, j, 0] > 200) and (pix[i, j, 1] > 200) and (pix[i, j, 2] > 200) then
pix[i, j, 3] := 0
else
pix[i, j, 3] := 255
end;
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 256, 128, 0, GL_RGBA, GL_UNSIGNED_BYTE, @pix);
glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
glEnable(GL_TEXTURE_2D);
end;

{ TGround }

destructor TGround.Annihilate;
begin
glDeleteLists(list, 1);
town := nil;
town.Free;
end;

constructor TGround.Create(pic: PChar; lnum : Integer;
                            xp, yp, zdegree: GLFloat);
begin
glPushMatrix;
glNewList(lnum, GL_COMPILE);
Load_Texture(pic);
glBegin(GL_QUADS);
glColor3f(1.0, 1.0, 1.0);
glTexCoord2f(0.0, 0.0);
glVertex3f(-1.0, 1.0, 0);
glTexCoord2f(1.0, 0.0);
glVertex3f(0.85, 1.0, 0.0);
glTexCoord2f(1.0, 1.0);
glVertex3f(0.85, -1.0, 0.0);
glTexCoord2f(0.0, 1.0);
glVertex3f(-1.0, -1.0, 0.0);
glEnd;
glEndList;
glPopMatrix;
list := lnum;
xpos := xp;
ypos := yp;
zdeg := zdegree;
showing := True;
end;

procedure TGround.Draw;
begin
if showing then begin
glPushMatrix;
glTranslatef(xpos, ypos, 0.0);
glRotatef(zdeg, 0.0, 0.0, 1.0);
glRotatef(180.0, 0.0, 1.0, 0.0);
glCallList(list);
glPopMatrix;
end;
end;

procedure TGround.Load_Texture(pic: PChar);
var
i, j : Integer;
bit : TBitmap;
pix : Array [0..511, 0..255, 0..3] of GLUByte;
begin
bit := TBitmap.Create;
bit.LoadFromFile(pic);
for i := 0 to 511 do
for j := 0 to 255 do begin
pix[i, j, 0] := GetRValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 1] := GetGValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 2] := GetBValue(bit.Canvas.Pixels[i, j]);{
if (pix[i, j, 0] > 150) and (pix[i, j, 1] > 150) and (pix[i, j, 2] > 150) then
pix[i, j, 3] := 0
else                             }
pix[i, j, 3] := 255
end;
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 256, 512, 0, GL_RGBA, GL_UNSIGNED_BYTE, @pix);
glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
glEnable(GL_TEXTURE_2D);
end;

{ TExplosion }

destructor TExplosion.Annihilate(num : Integer);
var
i, count : Integer;
begin
//if num = 0 then glDeleteLists(expl, 1);
count := 0;
made := False;
explosion[number] := nil;
explosion[number].Free;
for i := Low(explosion) to High(explosion) do
if explosion[i] <> nil then count := count + 1;
if count = 0 then begin
MaxExp := 0;
SetLength(explosion, MaxExp);
end;
//YazevWar.Caption := IntToStr(High(explosion))
end;

constructor TExplosion.Create(num, victnum, victkind : Integer; ww, hh, x, y,
                                                                 deg: GLFloat);
var
xp, yp : GLFloat;
begin
xp := 0.0 - ww / 2;
yp := 0.0 + hh / 2;
if num = 0 then begin
glPushMatrix;
glNewList(expl, GL_COMPILE);
Load_Texture;
glBegin(GL_QUADS);
glTexCoord2f(0.0, 0.0);
glVertex3f(xp, yp, 0.0);
glTexCoord2f(1.0, 0.0);
glVertex3f(xp + ww, yp, 0.0);
glTexCoord2f(1.0, 1.0);
glVertex3f(xp + ww, yp - hh, 0.0);
glTexCoord2f(0.0, 1.0);
glVertex3f(xp, yp - hh, 0.0);
glEnd;
glEndList;
glPopMatrix;
end;
number := num;
victimnumber := victnum;
victimkind:= victkind;
made := True;
xpos := x;
ypos := y;
lxpos := x;
lypos := y;
zdeg := deg;
LastSec := GetTickCount;
end;

procedure TExplosion.Draw(num : Integer);
var
x, y : GLFloat;
i : Integer;
begin
x := 0.0;
y := 0.0;
ThisSec := GetTickCount;
glPushMatrix;
if victimkind = -1 then begin                                            // by EnemyTanks
x := xpos;
y := ypos;
end else if (victimkind = 0) or (victimkind = 2) then begin // buildings & guns
x := xpos;
y := ypos;
end else if (victimkind = 1) and (Tanks[victimnumber] <> nil) then begin // Tanks
lxpos := xpos;
lypos := ypos;
x := Tanks[victimnumber].xpos;
y := Tanks[victimnumber].ypos;
end else if (victimkind = 1) and (Tanks[victimnumber] = nil) then begin
x := lxpos;
y := lypos;
end else if (victimkind = -2) and (YazevBattleTank <> nil) then begin // YazevBattleTank is shot down
lxpos := xpos;
lypos := ypos;
x := YazevBattleTank.xpos;
y := YazevBattleTank.ypos;
end else if (victimkind = -2) and (YazevBattleTank = nil) then begin
x := lxpos;
y := lypos;
end;
glTranslatef(x, y, 0.0);
glRotatef(zdeg, 0.0, 0.0, -1.0);
glCallList(expl);
glPopMatrix;
if ThisSec - LastSec > 500 then begin
if (victimkind = 0) and (buildings[victimnumber] <> nil) then begin
buildings[victimnumber].life := buildings[victimnumber].life - 1;
if buildings[victimnumber].life <= 0 then buildings[victimnumber].Explosion;
end else if (victimkind = 1) and (Tanks[victimnumber] <> nil) then begin
Tanks[victimnumber].life := Tanks[victimnumber].life - 1;
if Tanks[victimnumber].life <= 0 then Tanks[victimnumber].Explosion;
end else if (victimkind = -2) and (YazevBattleTank <> nil) then begin
YazevBattleTank.life := YazevBattleTank.life - 1;

for i := High(slifes) downto Low(slifes) do
if slifes[i] <> nil then begin
slifes[i].Die(i);
Break;
end;

if YazevBattleTank.life <= 0 then YazevBattleTank.Explosion;
end else if (victimkind = 2) and (guns[victimnumber] <> nil) then begin
guns[victimnumber].life := guns[victimnumber].life - 1;
if guns[victimnumber].life <= 0 then guns[victimnumber].Explosion;
end;
LastSec := GetTickCount;
Annihilate(num);
end;
end;

procedure TExplosion.Load_Texture;
var
i, j : Integer;
bit : TBitmap;
pix : Array [0..63, 0..127, 0..3] of GLUByte;
begin
bit := TBitmap.Create;
bit.LoadFromFile('explosion.bmp');
for i := 0 to 63 do
for j := 0 to 127 do begin
pix[i, j, 0] := GetRValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 1] := GetGValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 2] := GetBValue(bit.Canvas.Pixels[i, j]);
if (pix[i, j, 0] > 150) and (pix[i, j, 1] > 150) and (pix[i, j, 2] > 150) then
pix[i, j, 3] := 0
else
pix[i, j, 3] := 255
end;
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 128, 64, 0, GL_RGBA, GL_UNSIGNED_BYTE, @pix);
glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
glEnable(GL_TEXTURE_2D);
end;

{ TEnemyTank }

constructor TEnemyTank.Create(tank: PChar; num, lnum, lifes: Integer; ww, hh, x,
  y, deg: GLFloat);
var
xx, yy : GLFloat;
b : Bool;
j : Integer;
begin
made := True;
xx := 0.0 - tw / 2;
yy := 0.0 - th / 2;
b := False;
for j := Low(Tanks) to High(Tanks) do
if (Tanks[j] <> nil) and (Tanks[j].listnumber = lnum) then begin
b := True;
break;
end;
if not b then begin
glPushMatrix;
glNewList(lnum, GL_COMPILE);
Load_Tank(tank);
glBegin(GL_QUADS);
glColor3f(1.0, 1.0, 1.0);
glTexCoord2f(0.0, 0.0);
glVertex3f(xx, yy, 0);
glTexCoord2f(1.0, 0.0);
glVertex3f(xx + tw, yy, 0.0);
glTexCoord2f(1.0, 1.0);
glVertex3f(xx + tw, yy + th, 0.0);
glTexCoord2f(0.0, 1.0);
glVertex3f(xx, yy + th, 0.0);
glEnd;
glEndList;
glPopMatrix;
end;
active := True;
w := ww;
h := hh;
//h := ww;
xpos := x;
ypos := y;
zdeg := deg;
lxpos := x;
lypos := y;
life := lifes;
number := num;
listnumber := lnum;
LastSec := GetTickCount;

if (YazevBattleTank <> nil) and (YazevBattleTank.made) then
if (xpos + w / 2 > YazevBattleTank.xpos - YazevBattleTank.w / 2) and (xpos - w / 2 < YazevBattleTank.xpos + YazevBattleTank.w / 2) and
(ypos + w / 2 >= YazevBattleTank.ypos - YazevBattleTank.w / 2) and (ypos - w / 2 <= YazevBattleTank.ypos + YazevBattleTank.w / 2) then
if random(100) > 50 then
ypos := YazevBattleTank.ypos + w
else
ypos := YazevBattleTank.ypos - w;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//*****************************************************************************
// LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!!
for j := Low(bullet) to High(bullet) do
if (bullet[j] <> nil) and (bullet[j].made) then
if (xpos + w / 2 >= bullet[j].xpos - bullet[j].w / 2) and (xpos - w / 2 <= bullet[j].xpos + bullet[j].w / 2) and
(ypos + w / 2 >= bullet[j].ypos - bullet[j].w / 2) and (ypos - w / 2 <= bullet[j].ypos + bullet[j].w / 2) then bullet[j].Annihilate;
// LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!! LOOK OUT!!!
//*****************************************************************************
end;

procedure TEnemyTank.Draw;
const
{speed = 0.003;}
divisor = 3;
var
i : Integer;
b : Bool;
begin
b := False;

if not YazevWar.menumode then begin

ThisSec := GetTickCount;
if active then begin
xpos := xpos - cos(zdeg / sp) * speed;
ypos := ypos + sin(zdeg / sp) * speed;
for i := Low(buildings) to High(buildings) do
if (buildings[i] <> nil) and (not(buildings[i].remove)) then begin
if (xpos + w / 2 > buildings[i].xpos - buildings[i].w / 2) and (xpos - w / 2 < buildings[i].xpos + buildings[i].w / 2) and
(ypos + w / 2 >= buildings[i].ypos - buildings[i].h / 2) and (ypos - w / 2 <= buildings[i].ypos + buildings[i].h / 2) then begin
b := True;
xpos := lxpos; // √ениально!!!
ypos := lypos;
if random(100) > 50 then zdeg := zdeg + random(90) else zdeg := zdeg - random(90); // √ениально!!!
end;
end;

for i := Low(guns) to High(guns) do
if (guns[i] <> nil) {and (not(guns[i].remove))} then begin
if (xpos + w / 2 > guns[i].xpos - guns[i].w / 2) and (xpos - w / 2 < guns[i].xpos + guns[i].w / 2) and
(ypos + w / 2 >= guns[i].ypos - guns[i].h / 2) and (ypos - w / 2 <= guns[i].ypos + guns[i].h / 2) then begin
b := True;
xpos := lxpos; // √ениально!!!
ypos := lypos;
if random(100) > 50 then zdeg := zdeg + random(90) else zdeg := zdeg - random(90); // √ениально!!!
end;
end;

if (YazevBattleTank <> nil) and (YazevBattleTank.made) then begin
if (xpos + w / 2 > YazevBattleTank.xpos - YazevBattleTank.w / 2) and (xpos - w / 2 < YazevBattleTank.xpos + YazevBattleTank.w / 2) and
(ypos + w / 2 >= YazevBattleTank.ypos - YazevBattleTank.h / 2) and (ypos - w / 2 <= YazevBattleTank.ypos + YazevBattleTank.h / 2) then begin
b := True;
xpos := lxpos; // √ениально!!!
ypos := lypos;
if random(100) > 50 then zdeg := zdeg + random(90) else zdeg := zdeg - random(90); // √ениально!!!
end;
end;
      (*
if (YazevBattleTank <> nil) {and (not(Tanks[i].remove))} then begin
if (xpos + w / 2 > YazevBattleTank.xpos - YazevBattleTank.w / 2) and (xpos - w / 2 < YazevBattleTank.xpos + YazevBattleTank.w / 2) and
(ypos + w / 2 >= YazevBattleTank.ypos - YazevBattleTank.h / 2) and (ypos - w / 2 <= YazevBattleTank.ypos + YazevBattleTank.h / 2) then begin
//xpos := lxpos; // √ениально!!!
ypos := lypos;
xpos := xpos + (cos(zdeg / sp) * speed) / divisor
end;
if (xpos + w / 2 > YazevBattleTank.xpos - YazevBattleTank.w / 2) and (xpos - w / 2 < YazevBattleTank.xpos + YazevBattleTank.w / 2) and
(ypos + w / 2 >= YazevBattleTank.ypos - YazevBattleTank.h / 2) and (ypos - w / 2 <= YazevBattleTank.ypos + YazevBattleTank.h / 2) then begin
xpos := lxpos;
//ypos := lypos;
ypos := ypos + (sin(zdeg / sp) * speed) / divisor
end;
if (xpos + w / 2 > YazevBattleTank.xpos - YazevBattleTank.w / 2) and (xpos - w / 2 < YazevBattleTank.xpos + YazevBattleTank.w / 2) and
(ypos + w / 2 >= YazevBattleTank.ypos - YazevBattleTank.h / 2) and (ypos - w / 2 <= YazevBattleTank.ypos + YazevBattleTank.h / 2) then begin
xpos := lxpos;
ypos := lypos;
end;
end;
    *)
end;
(*
{if up then} xpos := xpos + (cos(zdeg / sp) * speed) / divisor;// else // _+_ --- √ениально!!!
//xpos := xpos - (cos(zdeg / sp) * speed) / divisor
end;
if (xpos + w / 2 > buildings[i].xpos - buildings[i].w / 2) and (xpos - w / 2 < buildings[i].xpos + buildings[i].w / 2) and
(ypos + w / 2 >= buildings[i].ypos - buildings[i].h / 2) and (ypos - w / 2 <= buildings[i].ypos + buildings[i].h / 2) then begin
xpos := lxpos;
//ypos := lypos;
{if up then} ypos := ypos + (sin(zdeg / sp) * speed) / divisor;// else
//ypos := ypos - (sin(zdeg / sp) * speed) / divisor
end;
if (xpos + w / 2 > buildings[i].xpos - buildings[i].w / 2) and (xpos - w / 2 < buildings[i].xpos + buildings[i].w / 2) and
(ypos + w / 2 >= buildings[i].ypos - buildings[i].h / 2) and (ypos - w / 2 <= buildings[i].ypos + buildings[i].h / 2) then begin
xpos := lxpos;
ypos := lypos;
end;
end;
*)
                             // √ениально!!! я гений!!! язев ёрий - гений!!!
if ThisSec - LastSec > 750 then begin
Fire;
LastSec := GetTickCount;
end;

if not b then begin
lxpos := xpos;
lypos := ypos;
end;
end;
glPushMatrix;
glTranslatef(xpos, ypos, 0.0);
glRotatef(-zdeg, 0.0, 0.0, 1.0);
glCallList(listnumber);
glPopMatrix;
end;

procedure TEnemyTank.Explosion;
begin
Die(number);
Tanks[number].Free;
end;

procedure TEnemyTank.Fire;
const
factor = 9;
begin
MaxBullets := MaxBullets + 1;
SetLength(bullet, MaxBullets);
bullet[MaxBullets - 1] := TBullet.Create(MaxBullets - 1, xpos, ypos, zdeg, False);
bullet[MaxBullets - 1].xdir := cos(zdeg / sp) * speed;
bullet[MaxBullets - 1].ydir := sin(zdeg / sp) * speed;
glPushMatrix;
with bullet[MaxBullets - 1] do begin
xpos := xpos - xdir * factor;
ypos := ypos + ydir * factor;
glTranslatef(xpos, ypos, 0.0);
glRotatef(-zdeg, 0.0, 0.0, 1.0);
end;
glPopMatrix;
end;

destructor TEnemyTank.Die(i: Integer);
var
j : Integer;
b : Bool;
begin
b := False;
active := False;
for j := Low(Tanks) to High(Tanks) do
if (Tanks[j] <> nil) and (number <> j) and
(listnumber = Tanks[j].listnumber) then begin
b := True;
Break;
end;
if not b then glDeleteLists(listnumber, 1);
Tanks[i] := nil;
end;

procedure TEnemyTank.Load_Tank(tank: PChar);
var
i, j : Integer;
bit : TBitmap;
pix : Array [0..63, 0..127, 0..3] of GLUByte;
begin
bit := TBitmap.Create;
bit.LoadFromFile(tank);
for i := 0 to 63 do
for j := 0 to 127 do begin
pix[i, j, 0] := GetRValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 1] := GetGValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 2] := GetBValue(bit.Canvas.Pixels[i, j]);
if (pix[i, j, 0] > 150) and (pix[i, j, 1] > 150) and (pix[i, j, 2] > 150) then
pix[i, j, 3] := 0
else
pix[i, j, 3] := 255
end;
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 128, 64, 0, GL_RGBA, GL_UNSIGNED_BYTE, @pix);
glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
glEnable(GL_TEXTURE_2D);
end;

procedure TYazevWar.YazevTankCreatorTimer(Sender: TObject); // √ениально!!!
var
i : Integer;
f : GLFloat;
begin
if (not buildings[14].destroy) and (not YazevWar.menumode) then begin
for i := Low(Tanks) to High(Tanks) do
if Tanks[i] = nil then begin
if random(180) > 90 then f := tank_params[i, 4] else f := -tank_params[i, 4];
Tanks[i] := TEnemyTank.Create(tank_images[i], tank_number[i, 0],
 tank_number[i, 1], tank_number[i, 2], tank_params[i, 0], tank_params[i, 1],
 tank_params[i, 2], tank_params[i, 3], f);
TanksCount := TanksCount + 1;
Break;
end else Continue;
if (YazevTankCreator.Interval = 2000) and (TanksCount = High(Tanks) + 1) then
YazevTankCreator.Interval := 5000;
end
end;

{ TGun }

constructor TGun.Create(base, gun: PChar; num, lifes: Integer; x, y,
  deg, turdeg: GLFloat; move : Bool);
const
lnum = 10;
lnum2 = 11;
lnum3 = 12;
gun_dead = 'gun_dead.bmp';
var
xx, yy : GLFloat;
b : Bool;
j : Integer;
tw, th : GLFloat;
begin
made := True;
b := False;
for j := Low(guns) to High(guns) do
if (guns[j] <> nil) and (guns[j].listnumber = lnum) then begin
b := True;
break;
end;
if not b then begin
tw := 0.15;
th := 0.15;
xx := 0.0 - tw / 2;
yy := 0.0 - th / 2;
glPushMatrix;
glNewList(lnum, GL_COMPILE);
Load_Tank(base);
glBegin(GL_QUADS);
glColor3f(1.0, 1.0, 1.0);
glTexCoord2f(0.0, 0.0);
glVertex3f(xx, yy, 0);
glTexCoord2f(1.0, 0.0);
glVertex3f(xx + tw, yy, 0.0);
glTexCoord2f(1.0, 1.0);
glVertex3f(xx + tw, yy + th, 0.0);
glTexCoord2f(0.0, 1.0);
glVertex3f(xx, yy + th, 0.0);
glEnd;
glEndList;
glNewList(lnum3, GL_COMPILE);
Load_Tank(gun_dead);
glBegin(GL_QUADS);
glColor3f(1.0, 1.0, 1.0);
glTexCoord2f(0.0, 0.0);
glVertex3f(xx, yy, 0);
glTexCoord2f(1.0, 0.0);
glVertex3f(xx + tw, yy, 0.0);
glTexCoord2f(1.0, 1.0);
glVertex3f(xx + tw, yy + th, 0.0);
glTexCoord2f(0.0, 1.0);
glVertex3f(xx, yy + th, 0.0);
glEnd;
glEndList;
glNewList(lnum2, GL_COMPILE);
tw := 0.2;
th := 0.1;
xx := 0.0 - tw / 2;
yy := 0.0 - th / 2;
glTranslatef(-0.035, 0.0, 0.0);
Load_Tank(gun);
glBegin(GL_QUADS);
glColor3f(1.0, 1.0, 1.0);
glTexCoord2f(0.0, 0.0);
glVertex3f(xx, yy, 0);
glTexCoord2f(1.0, 0.0);
glVertex3f(xx + tw, yy, 0.0);
glTexCoord2f(1.0, 1.0);
glVertex3f(xx + tw, yy + th, 0.0);
glTexCoord2f(0.0, 1.0);
glVertex3f(xx, yy + th, 0.0);
glEnd;
glEndList;
glPopMatrix;
end;
active := True;
alive := True;
xpos := x;
ypos := y;
w := 0.15;
h := 0.15;
zdeg := deg;
turZdeg := turdeg;
cturZdeg := turdeg;
life := lifes;
number := num;
listnumber := lnum;
listnumber2 := lnum2;
listnumber3 := lnum3;
remove := False;
sremove := move;
multiplier := 0.7;

LastSec := GetTickCount;
end;

destructor TGun.Die(i: Integer);
var
j : Integer;
b : Bool;
begin
b := False;
for j := Low(guns) to High(guns) do
if (guns[j] <> nil) and (number <> j) and
(listnumber = guns[j].listnumber) then begin
b := True;
Break;
end;
if not b then begin
glDeleteLists(listnumber, 1);
glDeleteLists(listnumber2, 1);
glDeleteLists(listnumber3, 1);
end;
guns[i] := nil;
end;

procedure TGun.Draw;
begin
if not YazevWar.menumode then begin
if alive then begin
ThisSec := GetTickCount;
turZdeg := turZdeg + multiplier;
if (turZdeg > cturZdeg + 30.0) or (turZdeg < cturZdeg - 30.0) then
multiplier := -multiplier;
if ThisSec - LastSec > 900 then begin
Fire;
LastSec := GetTickCount;
end;
end;
end;
glPushMatrix;
glTranslatef(xpos, ypos, 0.0);
glRotatef(-zdeg, 0.0, 0.0, 1.0);
if alive then begin
glCallList(listnumber);
glRotatef(-turZdeg, 0.0, 0.0, 1.0);
glCallList(listnumber2);
end else glCallList(listnumber3);
glPopMatrix;
end;

procedure TGun.Explosion;
begin
remove := sremove;
alive := False;
end;

procedure TGun.Fire;
const
factor = 9;
begin
MaxBullets := MaxBullets + 1;
SetLength(bullet, MaxBullets);
bullet[MaxBullets - 1] := TBullet.Create(MaxBullets - 1, xpos, ypos, turZdeg, False);
bullet[MaxBullets - 1].xdir := cos(turZdeg / sp) * speed;
bullet[MaxBullets - 1].ydir := sin(turZdeg / sp) * speed;
glPushMatrix;
with bullet[MaxBullets - 1] do begin
xpos := xpos - xdir * factor;
ypos := ypos + ydir * factor;
glTranslatef(xpos, ypos, 0.0);
glRotatef(-turZdeg, 0.0, 0.0, 1.0);
end;
glPopMatrix;
end;

procedure TGun.Load_Tank(tank: PChar);
var
i, j : Integer;
bit : TBitmap;
pix : Array [0..63, 0..127, 0..3] of GLUByte;
begin
bit := TBitmap.Create;
bit.LoadFromFile(tank);
for i := 0 to 63 do
for j := 0 to 127 do begin
pix[i, j, 0] := GetRValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 1] := GetGValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 2] := GetBValue(bit.Canvas.Pixels[i, j]);
if (pix[i, j, 0] > 200) and (pix[i, j, 1] > 200) and (pix[i, j, 2] > 200) then
pix[i, j, 3] := 0
else
pix[i, j, 3] := 255
end;
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 128, 64, 0, GL_RGBA, GL_UNSIGNED_BYTE, @pix);
glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
glEnable(GL_TEXTURE_2D);
end;

procedure TYazevWar.YazevBattleTankCreatorTimer(Sender: TObject);
begin
YazevBattleTank := TYazevBattleTank.Create(ytankimg);
YazevBattleTankCreator.Enabled := False;
end;

{ TLife }

constructor TLife.Create(pic: PChar; ww, hh, xp, yp, zd: GLFloat;
                         num, kind: Integer);
var
x, y, ltw, lth : GLFloat;
lTank, i : Integer;
b : Bool;
begin
b := False;
lTank := 0;
ltw := 0;
lth := 0;
if kind = 0 then begin
lTank := 13;
ltw := ww;
lth := hh;
if yimage <> nil then b := True;
end else
if kind = 1 then begin
lTank := 14;
ltw := tw / 2;
lth := th / 2;
for i := Low(slifes) to High(slifes) do
if slifes[i] <> nil then begin
b := True;
Break;
end
end else
if kind = 2 then begin
lTank := 15;
ltw := tw;
lth := th;
for i := Low(blifes) to High(blifes) do
if blifes[i] <> nil then begin
b := True;
Break;
end
end;
made := True;
x := 0.0 - ltw / 2;
y := 0.0 - lth / 2;
if not b then begin
glPushMatrix;
glNewList(lTank, GL_COMPILE);
if kind = 0 then Load_Tank2(pic) else Load_Tank(pic);
glBegin(GL_QUADS);
glColor3f(1.0, 1.0, 1.0);
glTexCoord2f(0.0, 0.0);
glVertex3f(x, y, 0);
glTexCoord2f(1.0, 0.0);
glVertex3f(x + ltw, y, 0.0);
glTexCoord2f(1.0, 1.0);
glVertex3f(x + ltw, y + lth, 0.0);
glTexCoord2f(0.0, 1.0);
glVertex3f(x, y + lth, 0.0);
glEnd;
glEndList;
glPopMatrix;
end;
number := num;
listnumber := lTank;
ckind := kind;
w := ltw;
h := lth;
xpos := xp;
ypos := yp;
zdeg := zd;
end;

destructor TLife.Die(i: Integer);
var
j : Integer;
b : Bool;
begin
b := False;
if ckind = 0 then begin
glDeleteLists(listnumber, 1);
yimage := nil;
yimage.Free;
end else
if ckind = 2 then begin
for j := Low(blifes) to High(blifes) do
if (blifes[j] <> nil) and (number <> j) and
(listnumber = blifes[j].listnumber) then begin
b := True;
Break;
end;
if not b then glDeleteLists(listnumber, 1);
blifes[i] := nil;
blifes[i].Free;
end else
if ckind = 1 then begin
for j := Low(slifes) to High(slifes) do
if (slifes[j] <> nil) and (number <> j) and
(listnumber = slifes[j].listnumber) then begin
b := True;
Break;
end;
if not b then glDeleteLists(listnumber, 1);
slifes[i] := nil;
slifes[i].Free;
end
end;

procedure TLife.Draw;
begin
glPushMatrix;
glTranslatef(xpos, ypos, 0.0);
glRotatef(-zdeg, 0.0, 0.0, 1.0);
glCallList(listnumber);
glPopMatrix;
end;

procedure TLife.Load_Tank(tank: PChar);
var
i, j : Integer;
bit : TBitmap;
pix : Array [0..63, 0..127, 0..3] of GLUByte;
begin
bit := TBitmap.Create;
bit.LoadFromFile(tank);
for i := 0 to 63 do
for j := 0 to 127 do begin
pix[i, j, 0] := GetRValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 1] := GetGValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 2] := GetBValue(bit.Canvas.Pixels[i, j]);
if (pix[i, j, 0] > 200) and (pix[i, j, 1] > 200) and (pix[i, j, 2] > 200) then
pix[i, j, 3] := 0
else
pix[i, j, 3] := 255
end;
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 128, 64, 0, GL_RGBA, GL_UNSIGNED_BYTE, @pix);
glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
glEnable(GL_TEXTURE_2D);
end;

procedure TLife.Load_Tank2(tank: PChar);
var
i, j : Integer;
bit : TBitmap;
pix : Array [0..255, 0..511, 0..3] of GLUByte;
begin
bit := TBitmap.Create;
bit.LoadFromFile(tank);
for i := 0 to 255 do
for j := 0 to 511 do begin
pix[i, j, 0] := GetRValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 1] := GetGValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 2] := GetBValue(bit.Canvas.Pixels[i, j]);
if (pix[i, j, 0] > 200) and (pix[i, j, 1] > 200) and (pix[i, j, 2] > 200) then
pix[i, j, 3] := 0
else
pix[i, j, 3] := 255
end;
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 512, 256, 0, GL_RGBA, GL_UNSIGNED_BYTE, @pix);
glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
glEnable(GL_TEXTURE_2D);
end;

procedure TYazevWar.YazevGameLoadingTimer(Sender: TObject);
var
i, o : Integer;
begin
o := 0;
for i := Low(blifes) to High(blifes) do
if blifes[i] = nil then begin
blifes[i] := TLife.Create('YazevBattleTank2.bmp', tw, th, -0.95 + 0.1 * i, -0.92, 90.0, i, 2);
Break;
end else begin
o := o + 1;
Continue;
end;
if o = High(blifes) + 1 then begin
Destroy_World;
Create_World;
YazevGameLoading.Enabled := False;
end;
//Caption := IntToStr(i);
end;

procedure TYazevWar.YazevBattleTankVictoryTimer(Sender: TObject);
begin
//GamePlay := False;
Destroy_World;
Victory := True;
//***************************************************
if not YazevMusicPlayer.Enabled then
YazevMusicPlayer.Enabled := True;
YazevMusicPlayer.FileName := DIO;
YazevMusicPlayer.Open;
YazevMusicPlayer.Play;
//***************************************************
Load('YazevBattleTank2Victory.bmp');
YazevBattleTankVictory.Enabled := False;
end;

procedure TYazevWar.YazevBattleTankDieTimer(Sender: TObject);
begin
Destroy_World;
//***************************************************
if not YazevMusicPlayer.Enabled then
YazevMusicPlayer.Enabled := True;
YazevMusicPlayer.FileName := Alice;
YazevMusicPlayer.Open;
YazevMusicPlayer.Play;
//***************************************************
Load('YazevBattleTank2ScreenOfDeath.bmp');
YazevBattleTankDie.Enabled := False;
end;

{ TMenu }

constructor TYazevMenu.Create;
const
m = 1000;
var
x, y, mw, mh : GLFloat;
begin
mw := 0.85;
mh := 0.5;
x := 0.0 - mw / 2;
y := 0.0 - mh / 2;
xpos := 0.0;
ypos := 0;
glPushMatrix;
glNewList(m, GL_COMPILE);
//Load_Tank(tank);
glColor3f(0.7, 0.5, 0.3);
glBegin(GL_QUADS);
glTexCoord2f(0.0, 0.0);
glVertex3f(x, y, 0);
glTexCoord2f(1.0, 0.0);
glVertex3f(x + mw, y, 0.0);
glTexCoord2f(1.0, 1.0);
glVertex3f(x + mw, y + mh, 0.0);
glTexCoord2f(0.0, 1.0);
glVertex3f(x, y + mh, 0.0);
glEnd;
glEndList;
glPopMatrix;
w := mw;
h := mh;
zdeg := 0.0;
number := m;
listnumber := m;
//******************************************
mw := 0.05;
mh := 0.05;
glPushMatrix;
glNewList(m + 1, GL_COMPILE);
//Load_Tank(tank);
glColor3f(1.0, 0.0, 0.0);
glBegin(GL_QUADS);
glTexCoord2f(0.0, 0.0);
glVertex3f(x, y, 0);
glTexCoord2f(1.0, 0.0);
glVertex3f(x + mw, y, 0.0);
glTexCoord2f(1.0, 1.0);
glVertex3f(x + mw, y + mh, 0.0);
glTexCoord2f(0.0, 1.0);
glVertex3f(x, y + mh, 0.0);
glEnd;
glEndList;
glPopMatrix;
w2 := mw;
h2 := mh;
xpos2 := 0.09;
ypos2 := 0.0;
zdeg2 := 45.0;
num2 := m + 1;
lnum2 := m + 1;
menucontrol := 0;
end;

destructor TYazevMenu.Die;
begin
glDeleteLists(listnumber, 1);
glDeleteLists(lnum2, 1);
ymenu := nil;
ymenu.Free;
end;

procedure TYazevMenu.Draw;
begin
case menucontrol of
0 : ypos2 := 0.0;
1 : ypos2 := -0.12;
2 : ypos2 := -0.24;
end;
glDisable(GL_TEXTURE_2D);
glEnable(GL_COLOR_MATERIAL);
glPushMatrix;
glTranslatef(xpos, ypos, 0.0);
glRotatef(-zdeg, 0.0, 0.0, 1.0);
glCallList(listnumber);
YazevWar.Output_TextGL;
glTranslatef(xpos2, ypos2, 0.0);
glRotatef(-zdeg2, 0.0, 0.0, 1.0);
glCallList(lnum2);
glPopMatrix;
glDisable(GL_COLOR_MATERIAL);
glEnable(GL_TEXTURE_2D);
end;

                (*
procedure TYazevMenu.Load_Tank(tank: PChar);
//var
begin
inherited;
{
i, j : Integer;
bit : TBitmap;
pix : Array [0..63, 0..127, 0..3] of GLUByte;
begin
bit := TBitmap.Create;
bit.LoadFromFile(tank);
for i := 0 to 63 do
for j := 0 to 127 do begin
pix[i, j, 0] := GetRValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 1] := GetGValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 2] := GetBValue(bit.Canvas.Pixels[i, j]);
if (pix[i, j, 0] > 200) and (pix[i, j, 1] > 200) and (pix[i, j, 2] > 200) then
pix[i, j, 3] := 0
else
pix[i, j, 3] := 255
end;
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 128, 64, 0, GL_RGBA, GL_UNSIGNED_BYTE, @pix);
glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
glEnable(GL_TEXTURE_2D);             }
end;

procedure TYazevMenu.Load_Tank2(tank: PChar);
{var
i, j : Integer;
bit : TBitmap;
pix : Array [0..255, 0..511, 0..3] of GLUByte;}
begin
inherited;
{bit := TBitmap.Create;
bit.LoadFromFile(tank);
for i := 0 to 255 do
for j := 0 to 511 do begin
pix[i, j, 0] := GetRValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 1] := GetGValue(bit.Canvas.Pixels[i, j]);
pix[i, j, 2] := GetBValue(bit.Canvas.Pixels[i, j]);
if (pix[i, j, 0] > 200) and (pix[i, j, 1] > 200) and (pix[i, j, 2] > 200) then
pix[i, j, 3] := 0
else
pix[i, j, 3] := 255
end;
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 512, 256, 0, GL_RGBA, GL_UNSIGNED_BYTE, @pix);
glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
glEnable(GL_TEXTURE_2D);}
end;
              *)

procedure TYazevWar.Init_TextGL;
begin
FillChar(lf, SizeOf(LOGFONT), 0);
with lf do begin
lfHeight := -20;
lfWidth := FW_HEAVY;
lfCharSet := ANSI_CHARSET;
lfOutPrecision := OUT_DEFAULT_PRECIS;
lfClipPrecision := CLIP_DEFAULT_PRECIS;
lfQuality := DEFAULT_QUALITY;
lfPitchAndFamily := FF_DONTCARE OR DEFAULT_PITCH;
end;
lstrcpy(lf.lfFaceName, 'Westwood Let');
heFont := CreateFontIndirect(lf);
hOldFont := SelectObject(DC, heFont);
if not wglUseFontOutlines(DC, 0, 255, GL_LETTERS, 0.0, 0.5, WGL_FONT_POLYGONS, NIL) then ShowMessage('Can''t output a text');
end;

procedure TYazevWar.Output_TextGL;
var
s : String;
begin
glColor3f(1.0, 1.0, 0.0);
glListBase(GL_LETTERS);
s := 'Resume game';
glPushMatrix;
glTranslatef(ymenu.xpos - 0.3, ymenu.ypos + 0.1, 0.0);
glPushMatrix;
glScalef(0.1, 0.1, 0.1);
glCallLists(Length(s), GL_UNSIGNED_BYTE, PChar(s));
glPopMatrix;
s := 'New game';
glTranslatef(0.0, -0.12, 0.0);
glPushMatrix;
glScalef(0.1, 0.1, 0.1);
glCallLists(Length(s), GL_UNSIGNED_BYTE, PChar(s));
s := 'Exit';
glPopMatrix;
glTranslatef(0.0, -0.12, 0.0);
glPushMatrix;
glScalef(0.1, 0.1, 0.1);
glCallLists(Length(s), GL_UNSIGNED_BYTE, PChar(s));
glPopMatrix;
glPopMatrix;
end;

procedure TYazevWar.YazevDelayTimer(Sender: TObject);
begin
delay := False;
YazevDelay.Enabled := False;
end;

procedure TYazevWar.YazevCloseUpTimer(Sender: TObject);
begin
Destroy_World;
//if yimage <> nil then yimage.Die(0);
Close;
//Exit;
end;

procedure TYazevWar.YazevMusicPlayerNotify(Sender: TObject);
begin
if (YazevMusicPlayer.NotifyValue = nvSuccessful) and
(YazevMusicPlayer.Position = YazevMusicPlayer.Length) then
if (YazevMusicPlayer.FileName = DIO) or (YazevMusicPlayer.FileName = Alice)
 then YazevMusicPlayer.Play else begin
m_num := m_num + 1;
Music_StartUp(m_num);
end
end;

end.
