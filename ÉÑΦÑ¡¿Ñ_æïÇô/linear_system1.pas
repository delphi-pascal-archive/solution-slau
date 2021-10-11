unit linear_system1;


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, system_surface,IdGlobal, Menus,lin_system1_about,
  XPMan, Buttons;
  
const
  A_LETTER=65;
  
type
  
  //La Classe du Système Linéaire
  linear_system=class
  private
  num_of_var:Integer;
  edit_mat:Array of Array of tedit;
  symbol_mat:Array of Array of tlabel;
  op_mat:Array of Array of tlabel;
  Real_mat:Array of Array of real;
  public

  constructor create(num_of_var:Integer);
  function system_is_valid():Boolean;
  procedure build_real_mat;
  procedure scale_real_mat;
  procedure show_result;
  procedure FormCenter;

  destructor   free;

end;

//La Classe de l'interface Utilisateur

Tfrm_lin_system = class(TForm)
  lbl_num_of_var: TLabel;
  edit_num_of_var: TEdit;
    frame_system_surface1: TSolutions;
  mnu_main: TMainMenu;
  APropos1: TMenuItem;
  APropos2: TMenuItem;
  XPManifest1: TXPManifest;
  btn_resolution_systeme: TBitBtn;
  btn_creer_systeme: TBitBtn;
  procedure btn_creer_systemeClick(Sender: TObject);
  procedure FormClose(Sender: TObject; var Action: TCloseAction);
  procedure APropos2Click(Sender: TObject);
  procedure btn_resolution_systemeClick(Sender: TObject);
  procedure FormCenter;
  private
  { Private declarations }

  public
  { Public declarations }
end;

var
  frm_lin_system: Tfrm_lin_system; //screen class ibject
  l:linear_system;                 //linear system object

    implementation

    {$R *.dfm}

//Boutton pour Créer le Système Linéaire

procedure Tfrm_lin_system.btn_creer_systemeClick(Sender: TObject);
var
  num,cod_err:Integer;
begin
  val(edit_num_of_var.Text,num,cod_err);
  if  (cod_err=0) and (num>=2)  then
  begin
    if l<>nil then l.Free;
    l:=linear_system.Create(StrToInt(edit_num_of_var.Text));
  end
  else begin
  ShowMessage('Un Nombre Invalide!!');
  exit;
end;
end;

//Création de l'Objet Système Linéaire Pour le Liberer Enfin

constructor linear_system.Create(num_of_var:Integer);
const
  INPUT_WIDTH=50;
  EDIT_VER_SPC=85;
  SYM_VER_SPC=52;
  OP_VER_SPC=63;
  HOR_SPC=50;
  LBL_FONT_SIZE=12;
  PLUS_SIGN='+';
  EQUAL_SIGN='=';
var
  i,j:Integer;
begin

  //Initialisation de la variable

  self.num_of_var:=num_of_var;

  //Allocation de la Mémoire

  setLength(edit_mat,num_of_var,num_of_var+1);
  setLength(symbol_mat,num_of_var,num_of_var);
  setLength(op_mat,num_of_var,num_of_var);
  Real_mat:=nil;

  //Construction des composants TEDITs

  for i:=0 to num_of_var-1 do
    for j:=0 to num_of_var do
  begin
    edit_mat[i,j]:=tedit.Create(frm_lin_system.frame_system_surface1);
    edit_mat[i,j].Parent:=frm_lin_system.frame_system_surface1;
    edit_mat[i,j].Width:=INPUT_WIDTH;
    edit_mat[i,j].Left:=j*EDIT_VER_SPC;
    edit_mat[i,j].Top:=i*HOR_SPC;
  end;

  //Construction des composants " Symboles: A,B,C....."

  for i:=0 to num_of_var-1 do
    for j:=0 to num_of_var-1 do
  begin
    symbol_mat[i,j]:=tlabel.Create(frm_lin_system.frame_system_surface1);
    symbol_mat[i,j].Parent:=frm_lin_system.frame_system_surface1;
    symbol_mat[i,j].Font.Size:=LBL_FONT_SIZE;
    symbol_mat[i,j].Caption:=Chr(A_LETTER+j);
    symbol_mat[i,j].Left:=j*EDIT_VER_SPC+SYM_VER_SPC;
    symbol_mat[i,j].Top:=i*HOR_SPC;
  end;

  //Construction des composants "+"

  for i:=0 to num_of_var-1 do
    for j:=0 to num_of_var-2 do
  begin
    op_mat[i,j]:=tlabel.Create(frm_lin_system.frame_system_surface1);
    op_mat[i,j].Parent:=frm_lin_system.frame_system_surface1;
    op_mat[i,j].Font.Size:=LBL_FONT_SIZE;
    op_mat[i,j].Caption:=PLUS_SIGN;
    op_mat[i,j].Left:=j*EDIT_VER_SPC+OP_VER_SPC;
    op_mat[i,j].Top:=i*HOR_SPC;
  end;

  //Construction des composants "="
  for i:=0 to num_of_var-1 do
    for j:=num_of_var-1 to num_of_var-1 do
  begin
    op_mat[i,j]:=tlabel.Create(frm_lin_system.frame_system_surface1);
    op_mat[i,j].Parent:=frm_lin_system.frame_system_surface1;
    op_mat[i,j].Font.Size:=LBL_FONT_SIZE;
    op_mat[i,j].Caption:=EQUAL_SIGN;
    op_mat[i,j].Left:=j*EDIT_VER_SPC+OP_VER_SPC;
    op_mat[i,j].Top:=i*HOR_SPC;
  end;

  frm_lin_system.btn_resolution_systeme.Visible:=True;
end;

//Controle de la validité du Système Linéaire
//Les coefficients doivent etre des nombres diffrents de Zéro

function  linear_system.system_is_valid():Boolean;
var
  i,j,num,err_cod:Integer;
  valid:Boolean;
begin
  valid:=True;
  i:=0;
  j:=0;
  while (i<=num_of_var-1) and valid do
  begin
    while (j<=num_of_var) and valid do
    begin
      val(edit_mat[i,j].Text,num,err_cod);
      if (err_cod<>0) or (num=0) then valid:=False;
      inc(j);
    end;
    inc(i);
  end;
  result:=valid;
end;

// construction de la matrice réelle dépend de la matrice de tedit

procedure linear_system.build_real_mat();
var
  i,j:Integer;
begin
  setLength(real_mat,num_of_var,num_of_var+1);
  for i:=0 to num_of_var-1 do
    for j:=0 to num_of_var do
     Real_mat[i,j]:=strtofloat(edit_mat[i,j].Text);
end;

//Echelle de la matrice Réelle
procedure linear_system.scale_real_mat;
var
  i,j,col_counter:Integer;
  mul_fac:Real;
begin
  for i:=0 to num_of_var-2 do
    for j:=i+1 to num_of_var-1 do
     begin
     mul_fac:=real_mat[j,i]/real_mat[i,i];
     Real_mat[j,i]:=0;
     for col_counter:=i+1 to num_of_var do
      Real_mat[j,col_counter]:=real_mat[j,col_counter]-real_mat[i,col_counter]*mul_fac;
     end;

  for i:=num_of_var-1 downto 1 do
    for j:=i-1 downto 0 do
    begin
     mul_fac:=real_mat[j,i]/real_mat[i,i];
     Real_mat[j,i]:=0;
     for col_counter:=i+1 to num_of_var do
      Real_mat[j,col_counter]:=real_mat[j,col_counter]-real_mat[i,col_counter]*mul_fac;
    end;

  for col_counter:=0 to num_of_var-1 do
    if Real_mat[col_counter,col_counter]<>0 then
    begin
     Real_mat[col_counter,num_of_var]:=real_mat[col_counter,num_of_var]/real_mat[col_counter,col_counter];
     Real_mat[col_counter,col_counter]:=1;
    end;
end;

// Afficher le résultat du système linéaire

procedure linear_system.show_result;
var
  i:Integer;
  str:String;
begin
  for i:=0 to num_of_var-1 do
    str:=str+Chr(65+i)+' = '+FloatToStr(real_mat[i,num_of_var])+#13+#10;

  ShowMessage(str);
end;

//La Form est Fermée

procedure Tfrm_lin_system.FormClose(Sender: TObject;var Action: TCloseAction);
begin

  if l<>nil
  then l.Free;

end;

//Si la Form est Fermé (( Programme Terminer )) Où un Nouveau Système Linéaire
//L'ancien système doit être Liberer de la mémoire

destructor linear_system.Free;
var
  i,j:Integer;
begin

  for i:=0 to num_of_var-1 do
    for j:=0 to num_of_var do
    edit_mat[i,j].Free;

  edit_mat:=nil;

  for i:=0 to num_of_var-1 do
    for j:=0 to num_of_var-1 do
    symbol_mat[i,j].Free;

  symbol_mat:=nil;

  for i:=0 to num_of_var-1 do
    for j:=0 to num_of_var-1 do
    op_mat[i,j].Free;

  op_mat:=nil;

  Real_mat:=nil;

end;

procedure linear_system.FormCenter;
begin
  with frm_lin_system do begin
  Left := Screen.Width  div 2 - Width  div 2;
  Top  := Screen.Height div 2 - Height div 2;
end;
end;


procedure Tfrm_lin_system.APropos2Click(Sender: TObject);
begin
  with frm_about do begin
  frm_about := Tfrm_about.Create(Application);
  FormCenter;
  AnimateWindow(Handle, 360, AW_BLEND);
  Show;
end;
end;

procedure Tfrm_lin_system.FormCenter;
begin
  with frm_about do begin
  Left := Screen.Width  div 2 - Width  div 2;
  Top  := Screen.Height div 2 - Height div 2;
end;
end;

procedure Tfrm_lin_system.btn_resolution_systemeClick(Sender: TObject);
begin
  if l.system_is_valid() then
  begin
    l.build_real_mat();
    l.scale_real_mat();
    l.show_result();
  end
  else ShowMessage('les coefficients des variables doivent être des numéros différents de zéro');
end;

end.
