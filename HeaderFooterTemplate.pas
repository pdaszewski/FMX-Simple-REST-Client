unit HeaderFooterTemplate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, System.JSON, IPPeerClient, REST.Client, Data.Bind.Components,
  DateUtils, Data.Bind.ObjectScope, FMX.ScrollBox, FMX.Memo, FMX.ListView.Appearances,
  FMX.Objects, FMX.Platform, FMX.VirtualKeyboard, System.Hash,
  FMX.Effects, System.Threading, idUri, IdGlobalProtocols, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, System.IOUtils,

  System.Permissions,

  {$IFDEF ANDROID}
  Androidapi.Helpers, Androidapi.JNI.Provider,
  FMX.Helpers.Android, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Net, Androidapi.JNI.JavaTypes,
  {$ENDIF}

  FMX.MultiView,
  FMX.Filter.Effects, FMX.Layouts, FMX.ListBox, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt;

type
  TLogowanie = class(TForm)
    BackgroundRect: TRectangle;
    VertScrollBox1: TVertScrollBox;
    LogoLayout: TLayout;
    LogoImage: TImage;
    FormLayout: TLayout;
    EmailEdit: TEdit;
    MailImage: TImage;
    PasswordEdit: TEdit;
    LockImage: TImage;
    AccountLayout: TLayout;
    CreateAccountText: TText;
    ForgetPasswordText: TText;
    FooterLayout: TLayout;
    ExperienceText: TText;
    HeaderToolBar: TToolBar;
    headerLabel: TLabel;
    InvertEffect2: TInvertEffect;
    InvertEffect3: TInvertEffect;
    OnClick: TTimer;
    CloseButton: TButton;
    GrayBox: TRectangle;
    lbl_pracuje: TLabel;
    AniIndicator: TAniIndicator;
    GlowEffect2: TGlowEffect;
    SterlingStyleBook: TStyleBook;
    pnl_close_alert: TRectangle;
    lbl_close_info: TLabel;
    ShadowEffect3: TShadowEffect;
    botton_segment: TRectangle;
    CloseButton_No: TButton;
    CloseButton_Yes: TButton;
    AuthenticateButton: TRectangle;
    AuthenticateLabel: TLabel;
    InvertEffect1: TInvertEffect;

    procedure EmailEditEnter(Sender: TObject);
    procedure PasswordEditEnter(Sender: TObject);
    procedure EmailEditTyping(Sender: TObject);
    procedure PasswordEditTyping(Sender: TObject);
    procedure CreateAccountTextTap(Sender: TObject; const Point: TPointF);
    procedure ForgetPasswordTextTap(Sender: TObject; const Point: TPointF);
    procedure OnClickTimer(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure CloseButton_NoClick(Sender: TObject);
    procedure CloseButton_YesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FamilyEditKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure AuthenticateButtonClick(Sender: TObject);
    procedure AuthenticateButtonTap(Sender: TObject; const Point: TPointF);
    procedure CreateAccountTextClick(Sender: TObject);
    procedure ForgetPasswordTextClick(Sender: TObject);
  private
   Var
    wybor : String;
  public

  end;

var
  Logowanie: TLogowanie;

implementation

{$R *.fmx}

uses RESTDataModule_frm, Categories_frm;


procedure TLogowanie.AuthenticateButtonClick(Sender: TObject);
begin
 OnClick.Enabled:=True;
 wybor:='login'
end;

procedure TLogowanie.AuthenticateButtonTap(Sender: TObject; const Point: TPointF);
begin
 InvertEffect1.Enabled:=True;
 OnClick.Enabled:=True;
 wybor:='login'
end;

procedure TLogowanie.CloseButtonClick(Sender: TObject);
begin
 pnl_close_alert.Visible:=True;
end;

procedure TLogowanie.CloseButton_NoClick(Sender: TObject);
begin
 pnl_close_alert.Visible:=False;
end;

procedure TLogowanie.CloseButton_YesClick(Sender: TObject);
begin
 Close;
end;

procedure TLogowanie.CreateAccountTextClick(Sender: TObject);
begin
 InvertEffect2.Enabled:=True;
 OnClick.Enabled:=True;
 wybor:='singup'
end;

procedure TLogowanie.CreateAccountTextTap(Sender: TObject;
  const Point: TPointF);
begin
 InvertEffect2.Enabled:=True;
 OnClick.Enabled:=True;
 wybor:='singup'
end;

procedure TLogowanie.ForgetPasswordTextClick(Sender: TObject);
begin
 InvertEffect3.Enabled:=True;
 OnClick.Enabled:=True;
 wybor:='help'
end;

procedure TLogowanie.ForgetPasswordTextTap(Sender: TObject; const Point: TPointF);
begin
 InvertEffect3.Enabled:=True;
 OnClick.Enabled:=True;
 wybor:='help'
end;

procedure TLogowanie.EmailEditEnter(Sender: TObject);
var
  FService: IFMXVirtualKeyboardService;
begin
 FService:=TPlatformServices.Current.GetPlatformService(IFMXVirtualKeyboardService) as IFMXVirtualKeyboardService;
 FService.ShowVirtualKeyboard(EmailEdit);
end;

procedure TLogowanie.EmailEditTyping(Sender: TObject);
begin
 if Trim(EmailEdit.Text)<>'' then MailImage.Visible:=False
 else MailImage.Visible:=True;
end;

procedure TLogowanie.FamilyEditKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  FService: IFMXVirtualKeyboardService;
begin
 if Key = vkReturn then
  Begin
   FService:=TPlatformServices.Current.GetPlatformService(IFMXVirtualKeyboardService) as IFMXVirtualKeyboardService;
   FService.HideVirtualKeyboard;
  End;
end;

procedure TLogowanie.FormCreate(Sender: TObject);
begin
 GrayBox.Visible:=False;
 pnl_close_alert.Visible:=False;
end;

procedure TLogowanie.PasswordEditEnter(Sender: TObject);
var
  FService: IFMXVirtualKeyboardService;
begin
 FService:=TPlatformServices.Current.GetPlatformService(IFMXVirtualKeyboardService) as IFMXVirtualKeyboardService;
 FService.ShowVirtualKeyboard(EmailEdit);
end;

procedure TLogowanie.PasswordEditTyping(Sender: TObject);
begin
 if Trim(PasswordEdit.Text)<>'' then LockImage.Visible:=False
 else LockImage.Visible:=True;
end;

procedure TLogowanie.OnClickTimer(Sender: TObject);
begin
 OnClick.Enabled:=False;
 InvertEffect1.Enabled:=False;
 InvertEffect2.Enabled:=False;
 InvertEffect3.Enabled:=False;

 if wybor='singup'  then ShowMessage('TO DO: Sing Up');
 if wybor='help'    then ShowMessage('TO DO: Help');
 if wybor='login'   then
  Begin
   Categories.Show;
  End;
end;

end.
