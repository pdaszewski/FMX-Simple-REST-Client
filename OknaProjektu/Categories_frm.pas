unit Categories_frm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.StdCtrls, FMX.Edit, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Platform, FMX.VirtualKeyboard, FMX.Gestures, System.JSON,
  System.ImageList, FMX.ImgList, FMX.Filter.Effects;

type
 kategorie = record
  id_nadrzedne : Integer;
  id_wlasne : Integer;
  nazwa : String;
  widoczny : Boolean;
 end;

type
  TCategories = class(TForm)
    HeaderToolBar: TToolBar;
    headerLabel: TLabel;
    BackButton: TButton;
    GrayBox: TRectangle;
    lbl_pracuje: TLabel;
    AniIndicator: TAniIndicator;
    GlowEffect2: TGlowEffect;
    ListLayout: TLayout;
    Rectangle1: TRectangle;
    CatList: TListView;
    BackgroundRect: TRectangle;
    GestureManager: TGestureManager;
    hamburger_menu: TButton;
    menu: TListView;
    IkonyMenu: TImageList;
    ShadowEffect4: TShadowEffect;

    procedure menuItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure Pobierz_dane_kategorii;

    procedure WynikListyKategorii(kod_odpowiedzi : Integer; kontent : string);

    procedure Utworz_menu;
    procedure Czysc_tablice_kategorii;
    procedure Wyswietl_liste;

    procedure BackButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CatListGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure CatListItemClick(const Sender: TObject; const AItem: TListViewItem);
    procedure hamburger_menuClick(Sender: TObject);
    procedure CatListTap(Sender: TObject; const Point: TPointF);
  private
   Var
    pozycja_ListScroll: Single;
    czy_tlo_zaladowane : Boolean;
    wybrana_kategoria_id_wlasne : Integer;
    wybrane_id_wlasne : Integer;
    dodaj_nadrzedna : Boolean;
    okno_aktywne : Boolean;
    KliknietyItem : TListViewItem;
    ktory_wyswietlic: Integer;

    operacja_nieudana                     : string;
    nazwa_pobieranie_kategorii            : string;
    menu_loading                          : string;
  public
    { Public declarations }
  end;

Const
 max_kategorii = 100;

var
  Categories: TCategories;
  tab: array[1..max_kategorii] of kategorie;


implementation

{$R *.fmx}

uses HeaderFooterTemplate, RESTDataModule_frm;

procedure TCategories.Pobierz_dane_kategorii;
Var
 zlecenie: TCategoryShow;
begin
  Czysc_tablice_kategorii;
  try
    try
      zlecenie := TCategoryShow.Create('1');
    finally
    end;
  except
    ShowMessage(operacja_nieudana);
  end;
end;

procedure TCategories.WynikListyKategorii(kod_odpowiedzi : Integer; kontent : string);
var
  Root: TJSONObject;
  Tablica: TJSONArray;
  Obiekt: TJSONObject;
  i: Integer;
  id_nadrzedne: Integer;
  id_wlasne: Integer;
  nazwa: string;
  ktory_element: Integer;
Begin
 if kod_odpowiedzi=200 then
  Begin
   Root    := TJSONObject.ParseJSONValue(kontent) as TJSONObject;
   Tablica := TJSONObject.ParseJSONValue(Root.GetValue('categories').ToString) as TJSONArray;
   if tablica.Count>0 then
    Begin
     ktory_element := 1;
     for i := 0 to tablica.Count-1 do
      Begin
       Obiekt := Tablica.Items[i] as TJSONObject;
       id_nadrzedne  := StrToInt(Obiekt.Values['main_id'].Value);
       id_wlasne     := StrToInt(Obiekt.Values['own_id'].Value);
       nazwa         := Trim(Obiekt.Values['name'].Value);
       tab[ktory_element].id_nadrzedne:=id_nadrzedne;
       tab[ktory_element].id_wlasne   :=id_wlasne;
       tab[ktory_element].nazwa       :=nazwa;
       tab[ktory_element].widoczny    :=True;
       Inc(ktory_element);
      End;
     End;

    if okno_aktywne then
     Begin
      Wyswietl_liste;
      GrayBox.Visible     :=False;
      AniIndicator.Enabled:=False;
     End;
  End
 else Pobierz_dane_kategorii;
End;

procedure TCategories.BackButtonClick(Sender: TObject);
begin
 Close;
 Logowanie.Show;
end;

procedure TCategories.menuItemClick(const Sender: TObject; const AItem: TListViewItem);
var
  i: Integer;
begin
 menu.Visible:=False;

 if AItem.Text=menu_loading then
  Begin
   GrayBox.Visible:=True;
   lbl_pracuje.Text:=nazwa_pobieranie_kategorii;
   AniIndicator.Enabled:=True;
   Pobierz_dane_kategorii;
  End;

end;

procedure TCategories.Wyswietl_liste;
Var
  item : TListViewItem;
  i: Integer;
  id_nadrzedne: Integer;
  id_wlasne: Integer;
  nazwa: String;
  miejsce_na_liscie: Integer;
  lista_kolejnosc : TStringList;
  linia: string;
  poz: Integer;
  it: Integer;
  id_wlasne_pom: Integer;
Begin
 lista_kolejnosc := TStringList.Create;
 pozycja_ListScroll := CatList.ScrollViewPos;
 CatList.BeginUpdate;
  CatList.Items.Clear;
 CatList.EndUpdate;

  for i := 1 to max_kategorii do
   Begin
    if tab[i].id_nadrzedne>-1 then
     Begin
      id_nadrzedne  := tab[i].id_nadrzedne;
      id_wlasne     := tab[i].id_wlasne;
      nazwa         := tab[i].nazwa;
      id_wlasne_pom := id_wlasne;
      if id_nadrzedne=0 then
       Begin
         lista_kolejnosc.Add(IntToStr(id_nadrzedne)+'-'+IntToStr(id_wlasne)+'-'+nazwa);
         for it := 1 to max_kategorii do
          Begin
           if (tab[it].id_nadrzedne=id_wlasne_pom) and (tab[it].widoczny=True) then
            Begin
             id_nadrzedne  := tab[it].id_nadrzedne;
             id_wlasne     := tab[it].id_wlasne;
             nazwa         := tab[it].nazwa;
             lista_kolejnosc.Add(IntToStr(id_nadrzedne)+'-'+IntToStr(id_wlasne)+'-'+nazwa);
            End;
          End;
       End;
     End;
   End;

 if lista_kolejnosc.Count>0 then
  Begin
   CatList.BeginUpdate;
   for i := 0 to lista_kolejnosc.Count-1 do
    Begin
     linia:=lista_kolejnosc.Strings[i];
     poz:=Pos('-',linia);  id_nadrzedne:=StrToInt(Trim(Copy(linia,1,poz-1))); Delete(linia,1,poz);
     poz:=Pos('-',linia);  id_wlasne:=StrToInt(Trim(Copy(linia,1,poz-1))); Delete(linia,1,poz);
     nazwa:=Trim(linia);

     if id_nadrzedne=0 then
       Begin
        item:=CatList.Items.Add;
        if id_wlasne=wybrana_kategoria_id_wlasne then ktory_wyswietlic:=item.Index;
        item.Objects.AccessoryObject.Visible:=False;
        item.Text:=nazwa;
        item.Height:=50;
        item.Data['id_nadrzedne'] := id_nadrzedne;
        item.Data['id_wlasne']    := id_wlasne;
        item.Objects.TextObject.PlaceOffset.X:=-7;
        item.Objects.TextObject.Font.Style  := [TFontStyle.fsBold];
        item.Objects.TextObject.TextColor   := TAlphaColors.Black;
        item.Objects.TextObject.Font.Size   := headerLabel.Font.Size;
          item.Objects.TextButton.Visible:=True;
          item.Objects.TextButton.Width:=30;
          item.Objects.TextButton.TextColor:=TAlphaColors.Black;
          item.ButtonText:='+';
       End;

      if id_nadrzedne>0 then
       Begin
        item:=CatList.Items.Add;
        item.Objects.AccessoryObject.Visible:=False;
        item.Objects.TextObject.Font.Style  := [];
        item.Objects.TextObject.TextColor   := TAlphaColors.Black;
        item.Objects.TextObject.Font.Size   := 15;
        item.Text:=nazwa;
        item.Height:=50;
        item.Data['id_nadrzedne'] := id_nadrzedne;
        item.Data['id_wlasne']    := id_wlasne;
       End;

    End;
    CatList.EndUpdate;
  End;
 lista_kolejnosc.Free;
End;

procedure TCategories.CatListGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
 case EventInfo.GestureID of

  igiLongTap :
   begin
    ShowMessage('Long Tap Gesture');
   end;

  igiDoubleTap :
   begin
    ShowMessage('Double Tap Gesture');
   end;

 end;

 Handled := True;
end;

procedure TCategories.CatListItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
 KliknietyItem:=AItem;
end;

procedure TCategories.CatListTap(Sender: TObject; const Point: TPointF);
begin
 menu.Visible:=False;
end;

procedure TCategories.Czysc_tablice_kategorii;
var
  i: Integer;
Begin
 for i := 1 to max_kategorii do
  Begin
   tab[i].id_nadrzedne:=-1;
   tab[i].id_wlasne:=-1;
   tab[i].nazwa:='';
   tab[i].widoczny:=False;
  End;
End;

procedure TCategories.FormCreate(Sender: TObject);
begin
 czy_tlo_zaladowane := False;
 Czysc_tablice_kategorii;
 okno_aktywne:=False;
 menu.Visible := False;
 menu.Position.Y := HeaderToolBar.Position.Y+HeaderToolBar.Height;

 menu_loading               := 'Show categories';
 operacja_nieudana          := 'Communication with REST failed!';
 nazwa_pobieranie_kategorii := 'Downloading categories list...';
end;

procedure TCategories.FormShow(Sender: TObject);
begin
 if czy_tlo_zaladowane=False then
  Begin
   GlowEffect2.GlowColor    := Logowanie.GlowEffect2.GlowColor;
   GrayBox.Fill             := Logowanie.GrayBox.Fill;
   BackgroundRect.Fill      := Logowanie.BackgroundRect.Fill;
   czy_tlo_zaladowane :=True;
  End;

 okno_aktywne:=True;
 menu.Visible:=False;

 GrayBox.Visible:=False;
 AniIndicator.Enabled:=False;
end;

procedure TCategories.hamburger_menuClick(Sender: TObject);
begin
 menu.Visible:=Not(menu.Visible);
 if menu.Visible then Utworz_menu;
end;

procedure TCategories.Utworz_menu;
Var
 item : TListViewItem;
Begin
  menu.BeginUpdate;
  menu.Items.Clear;

  item:=menu.Items.Add;
  item.Objects.AccessoryObject.Visible:=True;
  item.Text := menu_loading;
  item.ImageIndex:=1;
  item.Objects.ImageObject.Visible:=True;

 menu.EndUpdate;
End;

end.
