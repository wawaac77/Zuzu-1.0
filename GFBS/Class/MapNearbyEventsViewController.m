//
//  MapNearbyEventsViewController.m
//  GFBS
//
//  Created by Alice Jin on 15/6/2017.
//  Copyright © 2017 apple. All rights reserved.
//

#import "MapNearbyEventsViewController.h"

//#import "GFEventsCell.h"
//#import "GFEvent.h"
#import "EventInList.h"
#import "EventListCell.h"
#import "GFEventDetailViewController.h"
#import "KCAnnotation.h"

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

static NSString *const listEventID = @"event";

@class RestaurantDetail;


@interface MapNearbyEventsViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource> {
    MKMapView *map;
    //CLLocationManager *locationManager;
    //CLGeocoder *geocoder;
    
    UITableView *tableView;
}

/*所有帖子数据*/
@property (strong , strong)NSMutableArray<EventInList *> *nearbyEvents;
/*maxtime*/
@property (strong , nonatomic)NSString *maxtime;

/*请求管理者*/
@property (strong , nonatomic)GFHTTPSessionManager *manager;

@property (strong , nonatomic)CLLocationManager *locationManager;
@property (strong , nonatomic)CLGeocoder *geocoder;


@end


@implementation MapNearbyEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    [self setUpMap];
    [self loadNewEvents];
    
    [self setUpTableView];
    
    //[self setupRefresh];
}

#pragma mark - 懒加载
-(GFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [GFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return _manager;
}


- (void)setupRefresh
{
    tableView.mj_header = [GFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewEvents)];
    [tableView.mj_header beginRefreshing];
    
    //tableView.mj_footer = [GFRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/*******Here is reloading data place*****/
#pragma mark - 加载新数据
-(void)loadNewEvents
{
    NSLog(@"loadNewEvents工作了");
    //取消请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //2.凭借请求参数
    NSArray *geoPoint = @[@114, @22];
    NSDictionary *geoPointDic = @ {@"geoPoint" : geoPoint};
    NSDictionary *inData = @{
                             @"action" : @"getNearbyEventList",
                             @"data" : geoPointDic};
    NSDictionary *parameters = @{@"data" : inData};
    
    NSLog(@"Nearby events parameters %@", parameters);
    
    //发送请求
    [_manager POST:GetURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  responseObject) {
        
        //字典转模型//这是给topics数组赋值的地方
        NSLog(@"responseObject是接下来的%@", responseObject);
        NSLog(@"responseObject - data 是接下来的%@", responseObject[@"data"]);
        
        
        NSArray *eventsArray = responseObject[@"data"];
        
        
        self.nearbyEvents = [EventInList mj_objectArrayWithKeyValuesArray:eventsArray];
        NSLog(@"neaarbyEvents count in loadNewEvents%ld", _nearbyEvents.count);
        NSLog(@"nearbyEvents %@", self.nearbyEvents);
        [tableView reloadData];
        
        [tableView.mj_header endRefreshing];
        [self initGUI];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        NSLog(@"call api failed");
        
        [SVProgressHUD showWithStatus:@"Busy network, please try later~"];
        [tableView.mj_header endRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
    
}

- (void)setUpMap {
    /**mapView */
    map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.gf_width, self.view.gf_height - 400)];
    map.delegate = self;
    map.showsUserLocation = YES;
    map.mapType = MKMapTypeStandard;
    CLLocationCoordinate2D coor2d = {22.00, 114.52};
    MKCoordinateSpan span = {5, 5};
    MKCoordinateRegion region = {coor2d, span};
    
    //[map setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(29.4, 106.5), 5000, 5000) animated:YES];
    [map setRegion:region];
    map.showsUserLocation = YES;
    //CLLocationCoordinate2D *coords = CLLocationCoordinate2DMake(39.9, 116.4)
    
    [self.view addSubview:map];
    
    //定位管理器
    _locationManager = [[CLLocationManager alloc]init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
        NSLog(@"Start allocation!");
    }

    //[_locationManager stopUpdatingLocation];
    // Do any additional setup after loading the view from its nib.
    
    _geocoder=[[CLGeocoder alloc]init];
    [self getCoordinateByAddress:@"北京"];
    [self getAddressByLatitude:39.54 longitude:116.28];
    NSLog(@"neaarbyEvents count in setUpMap%ld", _nearbyEvents.count);
    
}

#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
}

#pragma mark - CLGeocoder 地理编码

#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark=[placemarks firstObject];
        
        CLLocation *location=placemark.location;//位置
        CLRegion *region=placemark.region;//区域
        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
    }];
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
    }];
}

#pragma mark 添加地图控件
-(void)initGUI{
    NSLog(@"initGUI start working");
    NSLog(@"neaarbyEvents count in initGUI%ld", _nearbyEvents.count);
    //请求定位服务
    //_locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    map.userTrackingMode=MKUserTrackingModeFollow;
    
    //添加大头针
    [self addAnnotation];
}

#pragma mark 添加大头针
-(void)addAnnotation{
    /*
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(39.95, 116.35);
    KCAnnotation *annotation1=[[KCAnnotation alloc]init];
    annotation1.title=@"CMJ Studio";
    annotation1.subtitle=@"Kenshin Cui's Studios";
    annotation1.coordinate=location1;
    [map addAnnotation:annotation1];
    NSLog(@"annotion1 added");
    
    CLLocationCoordinate2D location2=CLLocationCoordinate2DMake(39.87, 116.35);
    KCAnnotation *annotation2=[[KCAnnotation alloc]init];
    annotation2.title=@"Kenshin&Kaoru";
    annotation2.subtitle=@"Kenshin Cui's Home";
    annotation2.coordinate=location2;
    [map addAnnotation:annotation2];
     */
    NSLog(@"_nearbyEvents.count in addAnnotation = %ld", _nearbyEvents.count);
    for (int i = 0; i < _nearbyEvents.count; i++) {
        NSLog(@"start adding annotation!");
        EventInList *thisEvent = _nearbyEvents[i];
        NSArray *geo = thisEvent.listEventGeo;
        long double x = [[geo objectAtIndex:0] doubleValue];
        long double y = [[geo objectAtIndex:1] doubleValue];
        CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(x, y);
        KCAnnotation *annotation1=[[KCAnnotation alloc]init];
        annotation1.title=@"CMJ Studio";
        annotation1.subtitle=@"Kenshin Cui's Studios";
        annotation1.coordinate=location1;
        [map addAnnotation:annotation1];
        NSLog(@"annotion added");

        [map reloadInputViews];
    }
}

#pragma mark - 地图控件代理方法
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
    if ([annotation isKindOfClass:[KCAnnotation class]]) {
        static NSString *key1=@"AnnotationKey1";
        MKAnnotationView *annotationView=[map dequeueReusableAnnotationViewWithIdentifier:key1];
        //如果缓存池中不存在则新建
        if (!annotationView) {
            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
            annotationView.canShowCallout=true;//允许交互点击
            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_classify_cafe.png"]];//定义详情左侧视图
        }
        
        //修改大头针视图
        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
        annotationView.annotation=annotation;
        //annotationView.image=((KCAnnotation *)annotation).image;//设置大头针视图的图片
        annotationView.image = [UIImage imageNamed:@"grey_pin"];
        
        return annotationView;
    }else {
        return nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTableView {
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.gf_height - 400, self.view.gf_width, 400)];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    tableView.contentInset = UIEdgeInsetsMake(0, 0, GFTabBarH, 0);
    tableView.scrollIndicatorInsets = tableView.contentInset;
    //tableView.backgroundColor = [UIColor greenColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EventListCell class]) bundle:nil] forCellReuseIdentifier:listEventID];

    NSLog(@"neaarbyEvents count in setUpTable%ld", _nearbyEvents.count);
    [self.view addSubview:tableView];
    

    
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nearbyEvents.count;
}

- (EventListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    EventListCell *cell = [tableView dequeueReusableCellWithIdentifier:listEventID forIndexPath:indexPath];
    EventInList *thisEvent = self.nearbyEvents[indexPath.row];
    NSLog(@"thisEvent %@", thisEvent);
    cell.event = thisEvent;
    NSLog(@"-------------%ld", indexPath.row);
    NSLog(@"neaarbyEvents count in tableview cellForRowAtIndexPath%ld", _nearbyEvents.count);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFEventDetailViewController *eventDetailVC = [[GFEventDetailViewController alloc] init];
    //restaurantDetailVC.topic = self.tableView[indexPath.row];
    [self.navigationController pushViewController:eventDetailVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
