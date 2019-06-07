unit Categories_frm;

interface

uses
  System.SysUtils
  ,System.Types
  ,System.UITypes
  ,System.Classes
  ,System.Variants
  ,FMX.Types
  ,FMX.Controls
  ,FMX.Forms
  ,FMX.Graphics
  ,FMX.Dialogs
  ,FMX.Effects
  ,FMX.StdCtrls
  ,FMX.Edit
  ,FMX.Objects
  ,FMX.Layouts
  ,FMX.Controls.Presentation
  ,FMX.ListView.Types
  ,FMX.ListView.Appearances
  ,FMX.ListView.Adapters.Base
  ,FMX.ListView
  ,FMX.Platform
  ,FMX.VirtualKeyboard
  ,FMX.Gestures
  ,System.JSON
  ,System.ImageList
  ,FMX.ImgList
  ,FMX.Filter.Effects;

type
 categories_type = record
  main_id   : Integer;
  own_id    : Integer;
  name      : String;
  visible   : Boolean;
 end;

type
  TCategories = class(TForm)
    HeaderToolBar: TToolBar;
    headerLabel: TLabel;
    BackButton: TButton;
    GrayBox: TRectangle;
    lbl_working: TLabel;
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
    procedure Download_category_data;

    procedure Result_of_Category_List_Request(response_code : Integer; content : string);

    procedure Create_menu;
    procedure Clear_category_table;
    procedure Show_list;

    procedure BackButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CatListGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure hamburger_menuClick(Sender: TObject);
    procedure CatListTap(Sender: TObject; const Point: TPointF);
  private
   Var
    background_is_loaded : Boolean;
    active_window : Boolean;

    surgery_unsuccessful                  : string;
    name_of_category_collection           : string;
    menu_loading                          : string;
  public
    { Public declarations }
  end;

Const
 max_category = 100;

var
  Categories: TCategories;
  tab: array[1..max_category] of categories_type;


implementation

{$R *.fmx}

uses
  HeaderFooterTemplate
  ,RESTDataModule_frm;

procedure TCategories.Download_category_data;
Var
 thread_order: TCategoryShow;
begin
  Clear_category_table;
  try
    try
      thread_order := TCategoryShow.Create('1');
    finally
    end;
  except
    ShowMessage(surgery_unsuccessful);
  end;
end;

procedure TCategories.Result_of_Category_List_Request(response_code : Integer; content : string);
var
  Root: TJSONObject;
  GlobalArray: TJSONArray;
  ArrayObject: TJSONObject;
  i: Integer;
  main_id: Integer;
  own_id: Integer;
  name: string;
  which_element: Integer;
Begin
 if response_code=200 then
  Begin
   Root    := TJSONObject.ParseJSONValue(content) as TJSONObject;
   GlobalArray := TJSONObject.ParseJSONValue(Root.GetValue('categories').ToString) as TJSONArray;
   if GlobalArray.Count>0 then
    Begin
     which_element := 1;
     for i := 0 to GlobalArray.Count-1 do
      Begin
       ArrayObject  := GlobalArray.Items[i] as TJSONObject;
       main_id      := StrToInt(ArrayObject.Values['main_id'].Value);
       own_id       := StrToInt(ArrayObject.Values['own_id'].Value);
       name         := Trim(ArrayObject.Values['name'].Value);
       tab[which_element].main_id     :=main_id;
       tab[which_element].own_id      :=own_id;
       tab[which_element].name        :=name;
       tab[which_element].visible     :=True;
       Inc(which_element);
      End;
     End;

    if active_window then
     Begin
      Show_list;
      GrayBox.Visible     :=False;
      AniIndicator.Enabled:=False;
     End;
  End
 else Download_category_data;
End;

procedure TCategories.BackButtonClick(Sender: TObject);
begin
 Close;
 LoginForm.Show;
end;

procedure TCategories.menuItemClick(const Sender: TObject; const AItem: TListViewItem);
var
  i: Integer;
begin
 menu.Visible:=False;

 if AItem.Text=menu_loading then
  Begin
   GrayBox.Visible:=True;
   lbl_working.Text:=name_of_category_collection;
   AniIndicator.Enabled:=True;
   Download_category_data;
  End;

end;

procedure TCategories.Show_list;
Var
  item : TListViewItem;
  i: Integer;
  main_id: Integer;
  own_id: Integer;
  name: String;
  list_order : TStringList;
  line: string;
  position: Integer;
  it: Integer;
  own_id_ancillary: Integer;
Begin
 list_order := TStringList.Create;
 CatList.BeginUpdate;
  CatList.Items.Clear;
 CatList.EndUpdate;

  for i := 1 to max_category do
   Begin
    if tab[i].main_id>-1 then
     Begin
      main_id          := tab[i].main_id;
      own_id           := tab[i].own_id;
      name             := tab[i].name;
      own_id_ancillary := own_id;
      if main_id=0 then
       Begin
         list_order.Add(IntToStr(main_id)+'-'+IntToStr(own_id)+'-'+name);
         for it := 1 to max_category do
          Begin
           if (tab[it].main_id=own_id_ancillary) and (tab[it].visible=True) then
            Begin
             main_id        := tab[it].main_id;
             own_id         := tab[it].own_id;
             name           := tab[it].name;
             list_order.Add(IntToStr(main_id)+'-'+IntToStr(own_id)+'-'+name);
            End;
          End;
       End;
     End;
   End;

 if list_order.Count>0 then
  Begin
   CatList.BeginUpdate;
   for i := 0 to list_order.Count-1 do
    Begin
     line:=list_order.Strings[i];
     position:=Pos('-',line);  main_id:=StrToInt(Trim(Copy(line,1,position-1))); Delete(line,1,position);
     position:=Pos('-',line);  own_id:=StrToInt(Trim(Copy(line,1,position-1))); Delete(line,1,position);
     name:=Trim(line);

     if main_id=0 then
       Begin
        item:=CatList.Items.Add;
        item.Objects.AccessoryObject.Visible:=False;
        item.Text:=name;
        item.Height:=50;
        item.Data['main_id']    := main_id;
        item.Data['own_id']     := own_id;
        item.Objects.TextObject.PlaceOffset.X:=-7;
        item.Objects.TextObject.Font.Style  := [TFontStyle.fsBold];
        item.Objects.TextObject.TextColor   := TAlphaColors.Black;
        item.Objects.TextObject.Font.Size   := headerLabel.Font.Size;
          item.Objects.TextButton.Visible:=True;
          item.Objects.TextButton.Width:=30;
          item.Objects.TextButton.TextColor:=TAlphaColors.Black;
          item.ButtonText:='+';
       End;

      if main_id>0 then
       Begin
        item:=CatList.Items.Add;
        item.Objects.AccessoryObject.Visible:=False;
        item.Objects.TextObject.Font.Style  := [];
        item.Objects.TextObject.TextColor   := TAlphaColors.Black;
        item.Objects.TextObject.Font.Size   := 15;
        item.Text:=name;
        item.Height:=50;
        item.Data['main_id'] := main_id;
        item.Data['own_id']  := own_id;
       End;

    End;
    CatList.EndUpdate;
  End;
 list_order.Free;
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

procedure TCategories.CatListTap(Sender: TObject; const Point: TPointF);
begin
 menu.Visible:=False;
end;

procedure TCategories.Clear_category_table;
var
  i: Integer;
Begin
 for i := 1 to max_category do
  Begin
   tab[i].main_id:=-1;
   tab[i].own_id:=-1;
   tab[i].name:='';
   tab[i].visible:=False;
  End;
End;

procedure TCategories.FormCreate(Sender: TObject);
begin
 background_is_loaded := False;
 Clear_category_table;
 active_window:=False;
 menu.Visible := False;
 menu.Position.Y := HeaderToolBar.Position.Y+HeaderToolBar.Height;

 menu_loading                 := 'Show categories';
 surgery_unsuccessful         := 'Communication with REST failed!';
 name_of_category_collection  := 'Downloading categories list...';
end;

procedure TCategories.FormShow(Sender: TObject);
begin
 if background_is_loaded=False then
  Begin
   GlowEffect2.GlowColor    := LoginForm.GlowEffect2.GlowColor;
   GrayBox.Fill             := LoginForm.GrayBox.Fill;
   BackgroundRect.Fill      := LoginForm.BackgroundRect.Fill;
   background_is_loaded     :=True;
  End;

 active_window:=True;
 menu.Visible:=False;

 GrayBox.Visible:=False;
 AniIndicator.Enabled:=False;
end;

procedure TCategories.hamburger_menuClick(Sender: TObject);
begin
 menu.Visible:=Not(menu.Visible);
 if menu.Visible then Create_menu;
end;

procedure TCategories.Create_menu;
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
