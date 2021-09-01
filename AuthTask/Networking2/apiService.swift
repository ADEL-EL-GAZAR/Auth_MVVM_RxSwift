//
//  apiService.swift
//  TaqeemTeacher
//
//  Created by ADEL ELGAZAR on 4/14/20.
//  Copyright © 2020 ADEL ELGAZAR. All rights reserved.
//

import Moya

private let DefaultDownloadDestination: DownloadDestination = { temporaryURL, response in
    
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
}

enum apiService {
    // Account
    case authenticate(eMailOrPhoneNumber:String, password:String)
    case updateDeviceToken(deviceToken:String, deviceID:String, tokenType:Int)
    case logout(deviceToken:String, deviceID:String)
    case register(email:String, fullName:String, password:String, confirmPassword:String, phoneNumber:String, address:String, imagePath:String, lat:Double, lng:Double, loginType:Int, socialToken:String)
    case updateUser(email:String, fullName:String, phoneNumber:String, address:String, imagePath:String, lat:Double, lng:Double, isBusy:Bool)
    case checkEmail(Email:String)
    case checkPhoneNumber(PhoneNumber:String)
    case getLoggedInUser
    case activate(emailOrPhoneNumber:String, code:String)
    case upgradeToSeller(password:String, confirmPassword:String, retialDeliveringCenterID:String, deliveryLocationName:String, deliveryLocationLat:Double, deliveryLocationLng:Double, nationalID:String, frontNationalIdImageId:String, rearNationalIdImageId:String)
    case getUserById(UserID:String)
    case updateLocation(UserID:String)
    case forgetPassword(emailOrPhoneNumber:String)
    case resetPassword(emailOrPhoneNumber:String, virficationCode:String, password:String, confirmPassword:String)
    case authenticateWithSocial(tokenProvider:Int, userIdentifier:String)
    case socialRegister(fullName:String, email:String, phoneNumber:String, imagePath:String, address:String, lat:Double, lng:Double, tokenProvider:Int, userIdentifier:String)
    
    // Area
    case getAreaByCity(ID:Int)
    case saveArea(areaID:Int, localName:String, latinName:String, cityID:Int)
    
    // Category
    case getCategoryLookup
    case getFavouriteCategories

    // City
    case getAllCities
    
    // FavoritCategories
    case addCategoryToFavourite(categoryId:Int)
    case removeCategoryToFavourite(categoryId:Int)
    case updateFavouriteCategorys(categoriesIds:[Int])

    // File
    case upload(files:[Data], category:Int, isAudio:Bool)
    
    // Product
    case getListOfProducts
    case getProductLookup
    case autoComplete(Tirm:String)
    case save
    case getProductById(id:String)
    case deleteProduct(id:String)
    case searchProducts(categoryID:Int?, subCategory:Int?, priceFrom:Int?, priceTo:Int?, nearest:Bool?, searchText:String?, pageSize:Int, pageIndex:Int, lat:Double, lang:Double, sorting:Int?)
    case getHomeProducts(CategoryID:Int?)
    case addProduct(localName:String, localDescription:String, imageFilesIDs:[String], weightInKg:Double?, price:Int, preprationDays:Int, preprationHours:Int, preprationMinutes:Int, categoryID:Int)
    case updateProduct(productID:String, localName:String, localDescription:String, imageFilesIDs:[String], weightInKg:Double?, preprationDays:Int, preprationHours:Int, preprationMinutes:Int, categoryID:Int)
    case getProductRequests
    case getProductForEdit(id:String)
    case getProductDetailsForCustomer(ProductID:String)
    
    // Seller
    case getSellerLookup
    case addSeller
    case updateSeller
    case deleteSeller(userId:String)
    case getListSeller
    
    case getSettingsById(SettingID:String)
    case getOfferProducts
    case getFavouriteProducts
    
    case getPaymentTypes
    case getDeliveryTypes
    case getProductAvaliabilityTimes
    
    case updateProductActivationStatus(productID:String, isActive:Bool)
    
    case addItemToCart(productID:String, quantity:Int, extraNotes:String, overrideItems:Bool)
    case removeItemToCart(productID:String, quantity:Int)
    case removeProductFromCart(productID:String)
    case getCustomerCart
    
    case addProductToFavourite(productID:String)
    case removeProductFromFavourite(productID:String)
    
    case getInqueryTypes
    case addProductPromotion(productID:String, price:String, expirationTime:String)
    case deleteProductPromotion(ProductID:String)
    case createInquery(title:String, message:String, typeID:Int)
    
    case createOrderFromCart(extraNotes:String, coupon:String, paymentTypeID:Int, lat:Double, lang:Double, address:String, addressNote:String, presiste:Bool)
    case processOrderPayment(orderID:Int, paymentID:String, paymentAmount:String)
    case getPurchaseCouponDiscount(coupon:String, totalCost:String)
    case getSellerOrderItems
    case getCustomerOrderItems(orderStatuses:[Int])
    case preparingPackagedOrder(orderID:Int, preparingMins:Int)
    case preparingOrderItem(orderItemID:Int, preparingMins:Int, retailCenterID:String)
    case markPackagedOrderAsDelivered(orderID:Int, deliveringCode:String)
    case markAsDelevered(orderItemID:Int, deliveringCode:String)
    case getOrderItemStatus(OrderItemID:Int)

    case updateProductReview(productID:String, rate:Double, title:String, opinion:String, pros:String, cons:String)
    case removeProductReview(productID:String)
    
    case editProductPrice(productID:String, newPrice:String)
    case editProductQuantity(productID:String, oldQuantity:String, newQuantity:String)
    
    // Chat
    case sendMessage(toUserID:String, content:String, isVoiceMessage:Bool, voiceMessageFileID:String, attachmentIDs:[String])
    case deleteMessage(messageID:String)
    case getChatThreads(pageSize:Int, pageIndex:Int)
    case getChatThreadMessages(threadID:String, userID:String, searchText:String, pageSize:Int, pageIndex:Int)
    case markThreadAsSeen(threadID:String)

    case resendActivationCode(emailOrPhoneNumber:String)
    case resendResetPasswordCode(emailOrPhoneNumber:String)
    case verifyResetPasswordCode(emailOrPhoneNumber:String, code:String)
    case changePassword(currentPassword:String, newPassword:String, confirmPassword:String)
    case cancelOrderItem(orderItemID:Int)
    case cancelPackagedOrder(orderID:Int)

    case getReturnReasons
    case createReturnRequest(orderItemID:Int, returningReasonID:Int, returningExplination:String, fileIDs:[String])
    case createOrderComplain(orderID:Int?, orderItemID:Int?, title:String, message:String, attachmentsIDs:[String])
    
    // حسابي
    case getUserAccount
    case chargeUserAccount(chargedAmount:String, transactionID:String)
    case createWithdrawRequest(bankAccountNumber:String, swiftID:String, bankAccountOwnerName:String, bankID:Int, branchName:String, amount:String)
    case updateWithdrawRequestAcceptanceStatus(withdrawRequestID:String, isAccepted:Bool, bankTransferNumber:String)
    case getUserNotifications(pageSize:Int, pageIndex:Int)
    case markUserNotificationsAsSeen(notificationIDs:[String])

    case resendChangePhoneNumberCode(phoneNumber:String)
    case changePhoneNumber(phoneNumber:String, virficationCode:String)
    
    case getCartItemsCount
    case getUnseenUserNotificationsCount
    
    case addProductsToCart(items:[Product], overrideItems:Bool)
    case addProductsToFavourite(productIDs:[String])
    case getGlobalApplicationOptions
    
    case getUserAddressesList
    case addUserAddresses(lng:Double, lat:Double, locationName:String, title:String, addressDescription:String)
    case updateUserAddresses(id:String, lng:Double, lat:Double, locationName:String, title:String, addressDescription:String)
    case deleteUserAddresses(AddressId:String)
    
    case getDeliveryRetailsCenters
    case getSellerProfile(id:String)
    case getSellerLocations(id:String)
    case updateSellerLocation(retialDeliveringCenterID:String, deliveryLocationName:String, deliveryLocationLat:Double, deliveryLocationLng:Double)
    
    case saveUserCreditCard(token:String, transactionRef:String)
    case deleteUserCreditCard(id:String)
    case getUserCreditCards
    case getOrderDetials(orderID:String?, orderItemID:String?)
    
    case startOrderItemShipment(orderItemID:Int, retailCenterID:String)
    case downloadSamsaShippmentTicket(AwbNo:String)
    case getBanks
    case getLastWithdrawRequest
    
    case getMobileAppsOptions
    case setFroceUpdateVersion(secretKey:String, version:String)
    case checkPassword(Password:String)
}

// MARK: - TargetType Protocol Implementation
extension apiService: TargetType {
    var baseURL: URL { return URL(string: K_API_URL)! }
    
    var path: String {
        switch self {
        // Account
        case .authenticate:
            return "/Account/Authenticate"
        case .updateDeviceToken:
            return "/Account/UpdateDeviceToken"
        case .logout:
            return "/Account/Logout"
        case .register:
            return "/Account/Register"
        case .updateUser:
            return "/Account/Update"
        case .checkEmail:
            return "/Account/CheckEmail"
        case .checkPhoneNumber:
            return "/Account/CheckPhoneNumber"
        case .getLoggedInUser:
            return "/Account/GetLoggedInUser"
        case .activate:
            return "/Account/Activate"
        case .upgradeToSeller:
            return "/Account/UpgradeToSeller"
        case .getUserById(let id):
            return "/Account/GetById/\(id)"
        case .updateLocation:
            return "/Account/UpdateLocation"
        case .forgetPassword:
            return "/Account/ForgetPassword"
        case .resetPassword:
            return "/Account/ResetPassword"
        case .authenticateWithSocial:
            return "/Account/AuthenticateWithSocial"
        case .socialRegister:
            return "/Account/SocialRegister"
            
        // Area
        case .getAreaByCity:
            return "/Area/GetByCity"
        case .saveArea:
            return "/Area/Save"
            
        // Category
        case .getCategoryLookup:
            return "/Category/GetLookup"
        case .getFavouriteCategories:
            return "/FavoritCategories/GetUserFavoriteCategories"
            
        // City
        case .getAllCities:
            return "/City/GetAll"
            
        // FavoritCategories
        case .addCategoryToFavourite(let categoryId):
            return "/FavoritCategories/Add/\(categoryId)"
        case .removeCategoryToFavourite(let categoryId):
            return "/FavoritCategories/Delete/\(categoryId)"
        case .updateFavouriteCategorys:
            return "/FavoritCategories/Update"
            
        // File
        case .upload:
            return "/File/Upload"
            
        // Product
        case .getListOfProducts:
            return "/Admin/Product/GetList"
        case .getProductLookup:
            return "/Admin/Product/GetLookup"
        case .autoComplete:
            return "/Product/AutoComplete"
        case .save:
            return "/Admin/Product/Save"
        case .getProductById(let id):
            return "/Admin/Product/GetBy/\(id)"
        case .deleteProduct:
            return "/Product/Delete"
        case .searchProducts:
            return "/Product/Search"
        case .getHomeProducts:
            return "/Product/GetHomeProducts"
        case .addProduct:
            return "/Product/Create"
        case .updateProduct:
            return "/Product/Edit"
        case .getProductRequests:
            return "/Product/GetProductsRequests"
        case .getProductForEdit:
            return "/Product/GetProductForEdit"
        case .getProductDetailsForCustomer:
            return "/Product/GetProductDetailsForCustomer"
            
        // Seller
        case .getSellerLookup:
            return "/Admin/Seller/GetLookup"
        case .addSeller:
            return "/Admin/Seller/Add"
        case .updateSeller:
            return "/Admin/Product/Update"
        case .deleteSeller(let userId):
            return "/Admin/Seller/Delete/\(userId)"
        case .getListSeller:
            return "/Admin/Product/GetList"
            
        // Settings
        case .getSettingsById:
            return "/Settings/GetByID"
            
        case .getOfferProducts:
            return "/Product/Search"
        case .getFavouriteProducts:
            return "/Wishlist/GetCustomerWishlist"
            
        case .getPaymentTypes:
            return "/PaymentTypes/GetAll"
        case .getDeliveryTypes:
            return "/ProductDeliveringTypes/GetAll"
        case .getProductAvaliabilityTimes:
            return "/ProductAvaliabilityTimes/GetAll"
        case .updateProductActivationStatus:
            return "/Product/UpdateProductActivationStatus"
            
        case .addItemToCart:
            return "/Cart/AddItem"
        case .removeItemToCart:
            return "/Cart/RemoveItem"
        case .removeProductFromCart:
            return "/Cart/RemoveProduct"
        case .getCustomerCart:
            return "/Cart/GetCustomerCart"
            
        case .addProductToFavourite:
            return "/Wishlist/AddItem"
        case .removeProductFromFavourite:
            return "/Wishlist/RemoveItem"
        case .getInqueryTypes:
            return "/InqueryType/GetAll"
            
        case .addProductPromotion:
            return "/Product/AddProductPromotion"
        case .deleteProductPromotion:
            return "/Product/DeleteProductPromotion"
        case .createInquery:
            return "/Inquery/Create"
            
        case .createOrderFromCart:
            return "/Orders/CreateOrderFromCart"
        case .processOrderPayment:
            return "/Orders/ProcessOrderPayment"
        case .getPurchaseCouponDiscount:
            return "/PurchaseCoupons/GetPurchaseCouponDiscount"
        case .getSellerOrderItems:
            return "/Orders/GetSellerOrders"
        case .getCustomerOrderItems:
            return "/Orders/GetCustomerOrders"
        case .preparingPackagedOrder:
            return "/Orders/PreparingPackagedOrder"
        case .preparingOrderItem:
            return "/Orders/PreparingOrderItem"
        case .markPackagedOrderAsDelivered:
            return "/Orders/MarkPackagedOrderAsDelivered"
        case .markAsDelevered:
            return "/Orders/MarkOrderItemAsDelivered"
        case .getOrderItemStatus:
            return "/Orders/GetOrderItemTrackingStatus"
            
        case .updateProductReview:
            return "/ProductsReviews/UpdateProductReview"
        case .removeProductReview:
            return "/ProductsReviews/RemoveProductReview"
            
        case .editProductPrice:
            return "/Product/EditProductPrice"
        case .editProductQuantity:
            return "/Product/EditProductQuantity"
            
        case .sendMessage:
            return "/Chat/SendMessage"
        case .deleteMessage:
            return "/Chat/DeleteMessage"
        case .getChatThreads:
            return "/Chat/GetChatThreads"
        case .getChatThreadMessages:
            return "/Chat/GetChatThreadMessages"
        case .markThreadAsSeen:
            return "/Chat/MarkThreadAsSeen"
            
        case .resendActivationCode:
            return "/Account/ResendActivationCode"
        case .resendResetPasswordCode:
            return "/Account/ResendResetPasswordCode"
        case .verifyResetPasswordCode:
            return "/Account/VerifyResetPasswordCode"
        case .changePassword:
            return "/Account/ChangePassword"
        case .cancelOrderItem:
            return "/Orders/CancelOrderItem"
        case .cancelPackagedOrder:
            return "/Orders/CancelPackagedOrder"
            
        case .getReturnReasons:
            return "/ReturnOrderItemReasons/GetAll"
        case .createReturnRequest:
            return "/Orders/CreateReturnOrderItemRequest"
        case .createOrderComplain:
            return "/Inquery/CreateOrderComplain"
            
        case .getUserAccount:
            return "/UserAccount/GetUserAccount"
        case .chargeUserAccount:
            return "/UserAccount/ChargeUserAccount"
        case .createWithdrawRequest:
            return "/UserAccount/CreateWithdrawRequest"
        case .updateWithdrawRequestAcceptanceStatus:
            return "/UserAccount/UpdateWithdrawRequestAcceptanceStatus"
        case .getUserNotifications:
            return "/Notifications/GetUserNotifications"
        case .markUserNotificationsAsSeen:
            return "/Notifications/MarkUserNotificationsAsSeen"
            
        case .resendChangePhoneNumberCode:
            return "/Account/ResendChangePhoneNumberCode"
        case .changePhoneNumber:
            return "/Account/ChangePhoneNumber"
            
        case .getCartItemsCount:
            return "/Cart/GetCartItemsCount"
        case .getUnseenUserNotificationsCount:
            return "/Notifications/GetUnseenUserNotificationsCount"
            
        case .addProductsToCart:
            return "/Cart/AddItems"
        case .addProductsToFavourite:
            return "/Wishlist/AddItems"
        case .getGlobalApplicationOptions:
            return "/GlobalApplicationOptions/GetGlobalApplicationOptions"
            
        case .getUserAddressesList:
            return "/UserAddress/GetUserAddressesList"
        case .addUserAddresses:
            return "/UserAddress/Add"
        case .updateUserAddresses:
            return "/UserAddress/Update"
        case .deleteUserAddresses(let AddressId):
            return "/UserAddress/Delete/\(AddressId)"
            
        case .getDeliveryRetailsCenters:
            return "/DeliveryRetailsCenters/GetList"
        case .getSellerProfile(let id):
            return "/Sellers/GetSellerProfile/\(id)"
        case .getSellerLocations:
            return "/Sellers/GetSellerLocations"
        case .updateSellerLocation:
            return "/Sellers/UpdateSellerLocation"
            
        case .saveUserCreditCard:
            return "/UserCreditCard/Save"
        case .deleteUserCreditCard(let id):
            return "/UserCreditCard/Delete/\(id)"
        case .getUserCreditCards:
            return "/UserCreditCard/GetUserCreditCards"
            
        case .getOrderDetials:
            return "Orders/GetOrderDetials"
        case .startOrderItemShipment:
            return "/Orders/StartOrderItemShipment"
        case .downloadSamsaShippmentTicket:
            return "/Orders/DownloadSamsaShippmentTicket"
        case .getBanks:
            return "/Banks/GetAll"
        case .getLastWithdrawRequest:
            return "/UserAccount/GetLastWithdrawRequest"
            
        case .getMobileAppsOptions:
            return "/MobileAppsOptions/GetMobileAppsOptions"
        case .setFroceUpdateVersion:
            return "/MobileAppsOptions/SetFroceUpdateVersion"
        case .checkPassword:
            return "/Account/CheckPassword"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkEmail, .checkPhoneNumber, .getLoggedInUser, .getAreaByCity, .getAllCities, .getSettingsById, .getCategoryLookup, .getFavouriteCategories, .getHomeProducts, .addCategoryToFavourite, .removeCategoryToFavourite, .getFavouriteProducts, .autoComplete, .getPaymentTypes, .getDeliveryTypes, .getProductAvaliabilityTimes, .getProductRequests, .deleteProduct, .getProductForEdit, .getProductDetailsForCustomer, .getCustomerCart, .getInqueryTypes, .deleteProductPromotion, .getOrderItemStatus, .getReturnReasons, .getUserAccount, .getCartItemsCount, .getUnseenUserNotificationsCount, .getGlobalApplicationOptions, .getUserAddressesList, .deleteUserAddresses, .getDeliveryRetailsCenters, .getSellerProfile, .getSellerLocations, .deleteUserCreditCard, .getUserCreditCards, .downloadSamsaShippmentTicket, .getBanks, .getLastWithdrawRequest, .getMobileAppsOptions, .checkPassword:
            return .get
        default:
            return .post
        }
    }
    
    
    var parameters: [String: Any]? {
        switch self {
        case .authenticate(let eMailOrPhoneNumber, let password):
            var parameters = [String: Any]()
            parameters["eMailOrPhoneNumber"] = eMailOrPhoneNumber
            parameters["password"] = password
            return parameters
        case .updateDeviceToken(let deviceToken, let deviceID, let tokenType):
            var parameters = [String: Any]()
            parameters["deviceToken"] = deviceToken
            parameters["deviceID"] = deviceID
            parameters["tokenType"] = tokenType
            return parameters
        case .logout(let deviceToken, let deviceID):
            var parameters = [String: Any]()
            parameters["deviceToken"] = deviceToken
            parameters["deviceID"] = deviceID
            return parameters
        case .register(let email, let fullName, let password, let confirmPassword, let phoneNumber, let address, let imagePath, let lat, let lng, let loginType, let socialToken):
            var parameters = [String: Any]()
            parameters["email"] = email
            parameters["fullName"] = fullName
            parameters["password"] = password
            parameters["confirmPassword"] = confirmPassword
            parameters["phoneNumber"] = phoneNumber
            parameters["address"] = address
            parameters["imagePath"] = imagePath
            parameters["lat"] = lat
            parameters["lng"] = lng
            parameters["loginType"] = loginType
            parameters["socialToken"] = socialToken
            return parameters
        case .updateUser(let email, let fullName, let phoneNumber, let address, let imagePath, let lat, let lng, let isBusy):
            var parameters = [String: Any]()
            parameters["email"] = email
            parameters["fullName"] = fullName
            parameters["phoneNumber"] = phoneNumber
//            parameters["address"] = address
            parameters["imagePath"] = imagePath
//            parameters["lat"] = lat
//            parameters["lng"] = lng
            parameters["isBusy"] = isBusy
            return parameters
        case .checkEmail(let Email):
            var parameters = [String: Any]()
            parameters["Email"] = Email
            return parameters
        case .checkPhoneNumber(let PhoneNumber):
            var parameters = [String: Any]()
            parameters["PhoneNumber"] = PhoneNumber
            return parameters
        case .activate(let emailOrPhoneNumber, let code):
            var parameters = [String: Any]()
            parameters["emailOrPhoneNumber"] = emailOrPhoneNumber
            parameters["code"] = code
            return parameters
        case .getAreaByCity(let ID):
            var parameters = [String: Any]()
            parameters["ID"] = ID
            return parameters
        case .saveArea(let areaID, let localName, let latinName, let cityID):
            var parameters = [String: Any]()
            parameters["areaID"] = areaID
            parameters["localName"] = localName
            parameters["latinName"] = latinName
            parameters["cityID"] = cityID
            return parameters
        case .forgetPassword(let emailOrPhoneNumber):
            var parameters = [String: Any]()
            parameters["emailOrPhoneNumber"] = emailOrPhoneNumber
            return parameters
        case .resetPassword(let emailOrPhoneNumber, let virficationCode, let password, let confirmPassword):
            var parameters = [String: Any]()
            parameters["emailOrPhoneNumber"] = emailOrPhoneNumber
            parameters["virficationCode"] = virficationCode
            parameters["password"] = password
            parameters["confirmPassword"] = confirmPassword
            return parameters
        case .authenticateWithSocial(let tokenProvider, let userIdentifier):
            var parameters = [String: Any]()
            parameters["tokenProvider"] = tokenProvider
            parameters["userIdentifier"] = userIdentifier
            parameters["secretKey"] = "IosSecret213@645"
            return parameters
        case .socialRegister(let fullName, let email, let phoneNumber, let imagePath, let address, let lat, let lng, let tokenProvider, let userIdentifier):
            var parameters = [String: Any]()
            parameters["fullName"] = fullName
            parameters["email"] = email
            parameters["phoneNumber"] = phoneNumber
            parameters["imagePath"] = imagePath
            parameters["address"] = address
            parameters["lat"] = lat
            parameters["lng"] = lng
            parameters["tokenProvider"] = tokenProvider
            parameters["userIdentifier"] = userIdentifier
            parameters["secretKey"] = "IosSecret213@645"
            return parameters
            
        case .autoComplete(let Tirm):
            var parameters = [String: Any]()
            parameters["Tirm"] = Tirm
            return parameters
        case .searchProducts(let categoryID, let subCategory, let priceFrom, let priceTo, let nearest, let searchText, let pageSize, let pageIndex, let lat, let lang, let sorting):
            var parameters = [String: Any]()
            if categoryID != nil {
                parameters["categoryID"] = categoryID
            }
            if subCategory != nil {
                parameters["subCategory"] = subCategory
            }
            if priceFrom != nil {
                parameters["priceFrom"] = priceFrom
            }
            if priceTo != nil {
                parameters["priceTo"] = priceTo
            }
            if nearest != nil {
                parameters["nearest"] = nearest
            }
            if searchText != nil {
                parameters["searchText"] = searchText
            }
            if sorting != nil {
                parameters["sorting"] = sorting
            }
            parameters["lat"] = lat
            parameters["lang"] = lang
            parameters["pageSize"] = pageSize
            parameters["pageIndex"] = pageIndex
            return parameters
        case .upgradeToSeller(let password, let confirmPassword, let retialDeliveringCenterID, let deliveryLocationName, let deliveryLocationLat, let deliveryLocationLng, let nationalID, let frontNationalIdImageId, let rearNationalIdImageId):
            var parameters = [String: Any]()
            parameters["password"] = password
            parameters["confirmPassword"] = confirmPassword
            parameters["retialDeliveringCenterID"] = retialDeliveringCenterID
            parameters["deliveryLocationName"] = deliveryLocationName
            parameters["deliveryLocationLat"] = deliveryLocationLat
            parameters["deliveryLocationLng"] = deliveryLocationLng
            parameters["nationalID"] = nationalID
            parameters["frontNationalIdImageId"] = frontNationalIdImageId
            parameters["rearNationalIdImageId"] = rearNationalIdImageId
            return parameters
        case .addProduct(let localName, let localDescription, let imageFilesIDs, let weightInKg, let price, let preprationDays, let preprationHours, let preprationMinutes, let categoryID):
            var parameters = [String: Any]()
            parameters["localName"] = localName
            parameters["latinName"] = localName
            parameters["localDescription"] = localDescription
            parameters["latinDescription"] = localDescription
            parameters["imageFilesIDs"] = imageFilesIDs
            if weightInKg != nil {
                parameters["weightInKg"] = weightInKg
            }
            parameters["price"] = price
            parameters["preprationDays"] = preprationDays
            parameters["preprationHours"] = preprationHours
            parameters["preprationMinutes"] = preprationMinutes
            parameters["categoryID"] = categoryID
            return parameters
        case .updateProduct(let productID, let localName, let localDescription, let imageFilesIDs, let weightInKg, let preprationDays, let preprationHours, let preprationMinutes, let categoryID):
            var parameters = [String: Any]()
            parameters["productID"] = productID
            parameters["localName"] = localName
            parameters["latinName"] = localName
            parameters["localDescription"] = localDescription
            parameters["latinDescription"] = localDescription
            parameters["imageFilesIDs"] = imageFilesIDs
            if weightInKg != nil {
                parameters["weightInKg"] = weightInKg
            }
            parameters["preprationDays"] = preprationDays
            parameters["preprationHours"] = preprationHours
            parameters["preprationMinutes"] = preprationMinutes
            parameters["categoryID"] = categoryID
            return parameters
        case .deleteProduct(let id):
            var parameters = [String: Any]()
            parameters["id"] = id
            return parameters
        case .getProductForEdit(let id):
            var parameters = [String: Any]()
            parameters["id"] = id
            return parameters
        case .getProductDetailsForCustomer(let ProductID):
            var parameters = [String: Any]()
            parameters["ProductID"] = ProductID
            return parameters
            
        // Settings
        case .getSettingsById(let SettingID):
            var parameters = [String: Any]()
            parameters["SettingID"] = SettingID
            return parameters
            
        case .getHomeProducts(let CategoryID):
            var parameters = [String: Any]()
            if let cat = CategoryID {
                parameters["CategoryID"] = cat
            }
            return parameters
        case .getOfferProducts:
            var parameters = [String: Any]()
            parameters["subCategory"] = SubCategory.Promotions.category.id
            parameters["pageSize"] = 1000
            parameters["pageIndex"] = 0
            return parameters
            
        case .updateProductActivationStatus(let productID, let isActive):
            var parameters = [String: Any]()
            parameters["productID"] = productID
            parameters["isActive"] = isActive
            return parameters
            
        case .addItemToCart(let productID, let quantity, let extraNotes, let overrideItems):
            var parameters = [String: Any]()
            parameters["productID"] = productID
            parameters["quantity"] = quantity
            parameters["extraNotes"] = extraNotes
            parameters["overrideItems"] = overrideItems
            return parameters
        case .removeItemToCart(let productID, let quantity):
            var parameters = [String: Any]()
            parameters["productID"] = productID
            parameters["quantity"] = quantity
            return parameters
        case .removeProductFromCart(let productID):
            var parameters = [String: Any]()
            parameters["productID"] = productID
            return parameters
            
        case .addProductToFavourite(let productID):
            var parameters = [String: Any]()
            parameters["productID"] = productID
            return parameters
        case .removeProductFromFavourite(let productID):
            var parameters = [String: Any]()
            parameters["productID"] = productID
            return parameters
            
        case .addProductPromotion(let productID, let price, let expirationTime):
            var parameters = [String: Any]()
            parameters["productID"] = productID
            parameters["price"] = price
            parameters["expirationTime"] = expirationTime
            return parameters
        case .deleteProductPromotion(let ProductID):
            var parameters = [String: Any]()
            parameters["ProductID"] = ProductID
            return parameters
        case .createInquery(let title, let message, let typeID):
            var parameters = [String: Any]()
            parameters["title"] = title
            parameters["message"] = message
            parameters["typeID"] = typeID
            return parameters
            
        case .createOrderFromCart(let extraNotes, let coupon, let paymentTypeID, let lat, let lang, let address, let addressNote, let presiste):
            var parameters = [String: Any]()
            parameters["extraNotes"] = extraNotes
            parameters["coupon"] = coupon
            parameters["paymentTypeID"] = paymentTypeID
            parameters["lat"] = lat
            parameters["lang"] = lang
            parameters["address"] = address
            parameters["addressNote"] = addressNote
            parameters["presiste"] = presiste
            return parameters
        case .getPurchaseCouponDiscount(let coupon, let totalCost):
            var parameters = [String: Any]()
            parameters["coupon"] = coupon
            parameters["totalCost"] = totalCost
            return parameters
        case .processOrderPayment(let orderID, let paymentID, let paymentAmount):
            var parameters = [String: Any]()
            parameters["orderID"] = orderID
            parameters["paymentID"] = paymentID
            parameters["paymentAmount"] = paymentAmount
            return parameters
        case .preparingPackagedOrder(let orderID, let preparingMins):
            var parameters = [String: Any]()
            parameters["orderID"] = orderID
//            parameters["preparingMins"] = preparingMins
            return parameters
        case .preparingOrderItem(let orderItemID, let preparingMins, let retailCenterID):
            var parameters = [String: Any]()
            parameters["orderItemID"] = orderItemID
//            parameters["preparingMins"] = preparingMins
            parameters["retailCenterID"] = retailCenterID
            return parameters
        case .markPackagedOrderAsDelivered(let orderID, let deliveringCode):
            var parameters = [String: Any]()
            parameters["orderID"] = orderID
//            parameters["deliveringCode"] = deliveringCode
            return parameters
        case .markAsDelevered(let orderItemID, let deliveringCode):
            var parameters = [String: Any]()
            parameters["orderItemID"] = orderItemID
            parameters["deliveringCode"] = deliveringCode
            return parameters
        case .getOrderItemStatus(let OrderItemID):
            var parameters = [String: Any]()
            parameters["OrderItemID"] = OrderItemID
            return parameters
            
        case .updateProductReview(let productID, let rate, let title, let opinion, let pros, let cons):
            var parameters = [String: Any]()
            parameters["productID"] = productID
            parameters["rate"] = rate
            parameters["title"] = title
            parameters["opinion"] = opinion
            parameters["pros"] = pros
            parameters["cons"] = cons
            return parameters
        case .removeProductReview(let productID):
            var parameters = [String: Any]()
            parameters["productID"] = productID
            return parameters
            
        case .editProductPrice(let productID, let newPrice):
            var parameters = [String: Any]()
            parameters["productID"] = productID
            parameters["newPrice"] = newPrice
            return parameters
        case .editProductQuantity(let productID, let oldQuantity, let newQuantity):
            var parameters = [String: Any]()
            parameters["productID"] = productID
            parameters["oldQuantity"] = oldQuantity
            parameters["newQuantity"] = newQuantity
            return parameters
            
        case .sendMessage(let toUserID, let content, let isVoiceMessage, let voiceMessageFileID, let attachmentIDs):
            var parameters = [String: Any]()
            parameters["toUserID"] = toUserID
            parameters["content"] = content
            parameters["isVoiceMessage"] = isVoiceMessage
            parameters["voiceMessageFileID"] = voiceMessageFileID
            parameters["attachmentIDs"] = attachmentIDs
            return parameters
        case .deleteMessage(let messageID):
            var parameters = [String: Any]()
            parameters["messageID"] = messageID
            return parameters
        case .getChatThreads(let pageSize, let pageIndex):
            var parameters = [String: Any]()
            parameters["pageSize"] = pageSize
            parameters["pageIndex"] = pageIndex
            return parameters
        case .getChatThreadMessages(let threadID, let userID, let searchText, let pageSize, let pageIndex):
            var parameters = [String: Any]()
            parameters["threadID"] = threadID
            parameters["userID"] = userID
            parameters["searchText"] = searchText
            parameters["pageSize"] = pageSize
            parameters["pageIndex"] = pageIndex
            return parameters
        case .markThreadAsSeen(let threadID):
            var parameters = [String: Any]()
            parameters["threadID"] = threadID
            return parameters
            
        case .resendActivationCode(let emailOrPhoneNumber):
            var parameters = [String: Any]()
            parameters["emailOrPhoneNumber"] = emailOrPhoneNumber
            return parameters
        case .resendResetPasswordCode(let emailOrPhoneNumber):
            var parameters = [String: Any]()
            parameters["emailOrPhoneNumber"] = emailOrPhoneNumber
            return parameters
        case .verifyResetPasswordCode(let emailOrPhoneNumber, let code):
            var parameters = [String: Any]()
            parameters["emailOrPhoneNumber"] = emailOrPhoneNumber
            parameters["code"] = code
            return parameters
        case .changePassword(let currentPassword, let newPassword, let confirmPassword):
            var parameters = [String: Any]()
            parameters["currentPassword"] = currentPassword
            parameters["newPassword"] = newPassword
            parameters["confirmPassword"] = confirmPassword
            return parameters
        case .cancelOrderItem(let orderItemID):
            var parameters = [String: Any]()
            parameters["orderItemID"] = orderItemID
            return parameters
        case .cancelPackagedOrder(let orderID):
            var parameters = [String: Any]()
            parameters["orderID"] = orderID
            return parameters
            
        case .createReturnRequest(let orderItemID, let returningReasonID, let returningExplination, let fileIDs):
            var parameters = [String: Any]()
            parameters["orderItemID"] = orderItemID
            parameters["returningReasonID"] = returningReasonID
            parameters["returningExplination"] = returningExplination
            parameters["fileIDs"] = fileIDs
            return parameters
        case .createOrderComplain(let orderID, let orderItemID, let title, let message, let attachmentsIDs):
            var parameters = [String: Any]()
            if orderID != nil {
                parameters["orderID"] = orderID
            }
            if orderItemID != nil {
                parameters["orderItemID"] = orderItemID
            }
            parameters["title"] = title
            parameters["message"] = message
            parameters["attachmentsIDs"] = attachmentsIDs
            return parameters
            
        case .chargeUserAccount(let chargedAmount, let transactionID):
            var parameters = [String: Any]()
            parameters["chargedAmount"] = chargedAmount
            parameters["transactionID"] = transactionID
            return parameters
        case .createWithdrawRequest(let bankAccountNumber, let swiftID, let bankAccountOwnerName, let bankID, let branchName, let amount):
            var parameters = [String: Any]()
            parameters["bankAccountNumber"] = bankAccountNumber
            parameters["swiftID"] = swiftID
            parameters["bankAccountOwnerName"] = bankAccountOwnerName
            parameters["bankID"] = bankID
            parameters["branchName"] = branchName
            parameters["amount"] = amount
            return parameters
        case .updateWithdrawRequestAcceptanceStatus(let withdrawRequestID, let isAccepted, let bankTransferNumber):
            var parameters = [String: Any]()
            parameters["withdrawRequestID"] = withdrawRequestID
            parameters["isAccepted"] = isAccepted
            parameters["bankTransferNumber"] = bankTransferNumber
            return parameters
        case .getUserNotifications(let pageSize, let pageIndex):
            var parameters = [String: Any]()
            parameters["pageSize"] = pageSize
            parameters["pageIndex"] = pageIndex
            return parameters
            
        case .resendChangePhoneNumberCode(let phoneNumber):
            var parameters = [String: Any]()
            parameters["phoneNumber"] = phoneNumber
            return parameters
        case .changePhoneNumber(let phoneNumber, let virficationCode):
            var parameters = [String: Any]()
            parameters["phoneNumber"] = phoneNumber
            parameters["virficationCode"] = virficationCode
            return parameters
            
        case .addProductsToCart(let items, let overrideItems):
            var parameters = [String: Any]()
            var products:[Any] = []
            for item in items {
                var product = [String: Any]()
                product["productID"] = item.productID
                product["quantity"] = item.cartQuantity
                product["extraNotes"] = item.extraNotes
                product["overrideItems"] = overrideItems
                products.append(product)
            }
            parameters["items"] = products
            return parameters
        case .addProductsToFavourite(let productIDs):
            var parameters = [String: Any]()
            parameters["productIDs"] = productIDs
            return parameters
        case .markUserNotificationsAsSeen(let notificationIDs):
            var parameters = [String: Any]()
            parameters["notificationIDs"] = notificationIDs
            return parameters
            
        case .updateFavouriteCategorys(let categoriesIds):
            var parameters = [String: Any]()
            parameters["categoriesIds"] = categoriesIds
            return parameters
            
        case .addUserAddresses(let lng, let lat, let locationName, let title, let addressDescription):
            var parameters = [String: Any]()
            parameters["lng"] = lng
            parameters["lat"] = lat
            parameters["locationName"] = locationName
            parameters["title"] = title
            parameters["addressDescription"] = addressDescription
            return parameters
        case .updateUserAddresses(let id, let lng, let lat, let locationName, let title, let addressDescription):
            var parameters = [String: Any]()
            parameters["id"] = id
            parameters["lng"] = lng
            parameters["lat"] = lat
            parameters["locationName"] = locationName
            parameters["title"] = title
            parameters["addressDescription"] = addressDescription
            return parameters
        case .getSellerLocations(let id):
            var parameters = [String: Any]()
            parameters["id"] = id
            return parameters
        case .updateSellerLocation(let retialDeliveringCenterID, let deliveryLocationName, let deliveryLocationLat, let deliveryLocationLng):
            var parameters = [String: Any]()
            parameters["retialDeliveringCenterID"] = retialDeliveringCenterID
            parameters["deliveryLocationName"] = deliveryLocationName
            parameters["deliveryLocationLat"] = deliveryLocationLat
            parameters["deliveryLocationLng"] = deliveryLocationLng
            return parameters
            
        case .saveUserCreditCard(let token, let transactionRef):
            var parameters = [String: Any]()
            parameters["token"] = token
            parameters["transactionRef"] = transactionRef
            return parameters
            
        case .getCustomerOrderItems(let orderStatuses):
            var parameters = [String: Any]()
            parameters["orderStatuses"] = orderStatuses
            return parameters
            
        case .getOrderDetials(let orderID, let orderItemID):
            var parameters = [String: Any]()
            if orderID != nil {
                parameters["orderID"] = orderID
            }
            if orderItemID != nil {
                parameters["orderItemID"] = orderItemID
            }
            return parameters
            
        case .startOrderItemShipment(let orderItemID, let retailCenterID):
            var parameters = [String: Any]()
            parameters["orderItemID"] = orderItemID
            parameters["retailCenterID"] = retailCenterID
            return parameters
        case .downloadSamsaShippmentTicket(let AwbNo):
            var parameters = [String: Any]()
            parameters["AwbNo"] = AwbNo
            return parameters
            
        case .setFroceUpdateVersion(let secretKey, let version):
            var parameters = [String: Any]()
            parameters["secretKey"] = secretKey
            parameters["version"] = version
            return parameters
            
        case .checkPassword(let Password):
            var parameters = [String: Any]()
            parameters["Password"] = Password
            return parameters
            
        default:
            return [String: Any]()
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        return JSONEncoding.default
    }
    
    var task: Task {
        switch self {
        case .checkEmail, .checkPhoneNumber, .getLoggedInUser, .getAreaByCity, .getAllCities, .getSettingsById, .getCategoryLookup, .getFavouriteCategories, .getHomeProducts, .addCategoryToFavourite, .removeCategoryToFavourite, .getFavouriteProducts, .autoComplete, .getPaymentTypes, .getDeliveryTypes, .getProductAvaliabilityTimes, .getProductRequests, .deleteProduct, .getProductForEdit, .getProductDetailsForCustomer, .getCustomerCart, .getInqueryTypes, .deleteProductPromotion, .getOrderItemStatus, .getReturnReasons, .getUserAccount, .getCartItemsCount, .getUnseenUserNotificationsCount, .getGlobalApplicationOptions, .getUserAddressesList, .deleteUserAddresses, .getDeliveryRetailsCenters, .getSellerProfile, .getSellerLocations, .deleteUserCreditCard, .getUserCreditCards, .getBanks, .getLastWithdrawRequest, .getMobileAppsOptions, .checkPassword:
            return .requestParameters(parameters: parameters!, encoding: URLEncoding.queryString)
            
        case .upload(let files, let category, let isAudio):
            var multipartData = [MultipartFormData]()
            for (index, file) in files.enumerated() {
                if isAudio {
                    multipartData.append(MultipartFormData(provider: .data(file), name: "files", fileName: "files\(index).m4a", mimeType: "audio/m4a"))
                } else {
                    multipartData.append(MultipartFormData(provider: .data(file), name: "files", fileName: "files\(index).png", mimeType: "image/png"))
                }
            }
            multipartData.append(MultipartFormData(provider: .data("\(category)".data(using: .utf8)!), name: "category"))

            return .uploadMultipart(multipartData)
            
        case .downloadSamsaShippmentTicket(let AwbNo):
//            return .downloadDestination(DefaultDownloadDestination)
            return .downloadParameters(parameters: ["AwbNo": AwbNo], encoding: URLEncoding.queryString, destination: DefaultDownloadDestination)
            
        default:
            return .requestParameters(parameters: parameters!, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        print("\(K_Defaults.string(forKey: Saved.token) ?? "")")
        var parameters = [String: String]()
        parameters["Authorization"] = "Bearer \(K_Defaults.string(forKey: Saved.token) ?? "")"
        parameters["Accept-Language"] = "ar"
        //        parameters["Accept"] = "application/json"
        switch self {
        case .upload(_, _, _):
            parameters["Content-Type"] = "multipart/form-data"
        default:
            parameters["Content-Type"] = "application/json"
        }
        return parameters
    }
    
    var sampleData: Data {
        return Data()
    }
    
}
