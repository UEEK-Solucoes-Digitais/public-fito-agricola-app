import 'package:phosphor_flutter/phosphor_flutter.dart';

class IconsList {
  static PhosphorIconData getIcon(String icon) {
    return regularIcons[icon] != null
        ? regularIcons[icon]!
        : regularIcons['question']!;
  }

  static Map<String, PhosphorIconData> get regularIcons => {
        'address-book': PhosphorIcons.addressBook(PhosphorIconsStyle.regular),
        'airplane': PhosphorIcons.airplane(PhosphorIconsStyle.regular),
        'airplane-in-flight':
            PhosphorIcons.airplaneInFlight(PhosphorIconsStyle.regular),
        'airplane-landing':
            PhosphorIcons.airplaneLanding(PhosphorIconsStyle.regular),
        'airplane-takeoff':
            PhosphorIcons.airplaneTakeoff(PhosphorIconsStyle.regular),
        'airplane-tilt': PhosphorIcons.airplaneTilt(PhosphorIconsStyle.regular),
        'airplay': PhosphorIcons.airplay(PhosphorIconsStyle.regular),
        'air-traffic-control':
            PhosphorIcons.airTrafficControl(PhosphorIconsStyle.regular),
        'alarm': PhosphorIcons.alarm(PhosphorIconsStyle.regular),
        'alien': PhosphorIcons.alien(PhosphorIconsStyle.regular),
        'align-bottom': PhosphorIcons.alignBottom(PhosphorIconsStyle.regular),
        'align-bottom-simple':
            PhosphorIcons.alignBottomSimple(PhosphorIconsStyle.regular),
        'align-center-horizontal':
            PhosphorIcons.alignCenterHorizontal(PhosphorIconsStyle.regular),
        'align-center-horizontal-simple':
            PhosphorIcons.alignCenterHorizontalSimple(
                PhosphorIconsStyle.regular),
        'align-center-vertical':
            PhosphorIcons.alignCenterVertical(PhosphorIconsStyle.regular),
        'align-center-vertical-simple':
            PhosphorIcons.alignCenterVerticalSimple(PhosphorIconsStyle.regular),
        'align-left': PhosphorIcons.alignLeft(PhosphorIconsStyle.regular),
        'align-left-simple':
            PhosphorIcons.alignLeftSimple(PhosphorIconsStyle.regular),
        'align-right': PhosphorIcons.alignRight(PhosphorIconsStyle.regular),
        'align-right-simple':
            PhosphorIcons.alignRightSimple(PhosphorIconsStyle.regular),
        'align-top': PhosphorIcons.alignTop(PhosphorIconsStyle.regular),
        'align-top-simple':
            PhosphorIcons.alignTopSimple(PhosphorIconsStyle.regular),
        'amazon-logo': PhosphorIcons.amazonLogo(PhosphorIconsStyle.regular),
        'anchor': PhosphorIcons.anchor(PhosphorIconsStyle.regular),
        'anchor-simple': PhosphorIcons.anchorSimple(PhosphorIconsStyle.regular),
        'android-logo': PhosphorIcons.androidLogo(PhosphorIconsStyle.regular),
        'angular-logo': PhosphorIcons.angularLogo(PhosphorIconsStyle.regular),
        'aperture': PhosphorIcons.aperture(PhosphorIconsStyle.regular),
        'apple-logo': PhosphorIcons.appleLogo(PhosphorIconsStyle.regular),
        'apple-podcasts-logo':
            PhosphorIcons.applePodcastsLogo(PhosphorIconsStyle.regular),
        'app-store-logo':
            PhosphorIcons.appStoreLogo(PhosphorIconsStyle.regular),
        'app-window': PhosphorIcons.appWindow(PhosphorIconsStyle.regular),
        'archive': PhosphorIcons.archive(PhosphorIconsStyle.regular),
        'armchair': PhosphorIcons.armchair(PhosphorIconsStyle.regular),
        'arrow-arc-left':
            PhosphorIcons.arrowArcLeft(PhosphorIconsStyle.regular),
        'arrow-arc-right':
            PhosphorIcons.arrowArcRight(PhosphorIconsStyle.regular),
        'arrow-bend-double-up-left':
            PhosphorIcons.arrowBendDoubleUpLeft(PhosphorIconsStyle.regular),
        'arrow-bend-double-up-right':
            PhosphorIcons.arrowBendDoubleUpRight(PhosphorIconsStyle.regular),
        'arrow-bend-down-left':
            PhosphorIcons.arrowBendDownLeft(PhosphorIconsStyle.regular),
        'arrow-bend-down-right':
            PhosphorIcons.arrowBendDownRight(PhosphorIconsStyle.regular),
        'arrow-bend-left-down':
            PhosphorIcons.arrowBendLeftDown(PhosphorIconsStyle.regular),
        'arrow-bend-left-up':
            PhosphorIcons.arrowBendLeftUp(PhosphorIconsStyle.regular),
        'arrow-bend-right-down':
            PhosphorIcons.arrowBendRightDown(PhosphorIconsStyle.regular),
        'arrow-bend-right-up':
            PhosphorIcons.arrowBendRightUp(PhosphorIconsStyle.regular),
        'arrow-bend-up-left':
            PhosphorIcons.arrowBendUpLeft(PhosphorIconsStyle.regular),
        'arrow-bend-up-right':
            PhosphorIcons.arrowBendUpRight(PhosphorIconsStyle.regular),
        'arrow-circle-down':
            PhosphorIcons.arrowCircleDown(PhosphorIconsStyle.regular),
        'arrow-circle-down-left':
            PhosphorIcons.arrowCircleDownLeft(PhosphorIconsStyle.regular),
        'arrow-circle-down-right':
            PhosphorIcons.arrowCircleDownRight(PhosphorIconsStyle.regular),
        'arrow-circle-left':
            PhosphorIcons.arrowCircleLeft(PhosphorIconsStyle.regular),
        'arrow-circle-right':
            PhosphorIcons.arrowCircleRight(PhosphorIconsStyle.regular),
        'arrow-circle-up':
            PhosphorIcons.arrowCircleUp(PhosphorIconsStyle.regular),
        'arrow-circle-up-left':
            PhosphorIcons.arrowCircleUpLeft(PhosphorIconsStyle.regular),
        'arrow-circle-up-right':
            PhosphorIcons.arrowCircleUpRight(PhosphorIconsStyle.regular),
        'arrow-clockwise':
            PhosphorIcons.arrowClockwise(PhosphorIconsStyle.regular),
        'arrow-counter-clockwise':
            PhosphorIcons.arrowCounterClockwise(PhosphorIconsStyle.regular),
        'arrow-down': PhosphorIcons.arrowDown(PhosphorIconsStyle.regular),
        'arrow-down-left':
            PhosphorIcons.arrowDownLeft(PhosphorIconsStyle.regular),
        'arrow-down-right':
            PhosphorIcons.arrowDownRight(PhosphorIconsStyle.regular),
        'arrow-elbow-down-left':
            PhosphorIcons.arrowElbowDownLeft(PhosphorIconsStyle.regular),
        'arrow-elbow-down-right':
            PhosphorIcons.arrowElbowDownRight(PhosphorIconsStyle.regular),
        'arrow-elbow-left':
            PhosphorIcons.arrowElbowLeft(PhosphorIconsStyle.regular),
        'arrow-elbow-left-down':
            PhosphorIcons.arrowElbowLeftDown(PhosphorIconsStyle.regular),
        'arrow-elbow-left-up':
            PhosphorIcons.arrowElbowLeftUp(PhosphorIconsStyle.regular),
        'arrow-elbow-right':
            PhosphorIcons.arrowElbowRight(PhosphorIconsStyle.regular),
        'arrow-elbow-right-down':
            PhosphorIcons.arrowElbowRightDown(PhosphorIconsStyle.regular),
        'arrow-elbow-right-up':
            PhosphorIcons.arrowElbowRightUp(PhosphorIconsStyle.regular),
        'arrow-elbow-up-left':
            PhosphorIcons.arrowElbowUpLeft(PhosphorIconsStyle.regular),
        'arrow-elbow-up-right':
            PhosphorIcons.arrowElbowUpRight(PhosphorIconsStyle.regular),
        'arrow-fat-down':
            PhosphorIcons.arrowFatDown(PhosphorIconsStyle.regular),
        'arrow-fat-left':
            PhosphorIcons.arrowFatLeft(PhosphorIconsStyle.regular),
        'arrow-fat-line-down':
            PhosphorIcons.arrowFatLineDown(PhosphorIconsStyle.regular),
        'arrow-fat-line-left':
            PhosphorIcons.arrowFatLineLeft(PhosphorIconsStyle.regular),
        'arrow-fat-line-right':
            PhosphorIcons.arrowFatLineRight(PhosphorIconsStyle.regular),
        'arrow-fat-lines-down':
            PhosphorIcons.arrowFatLinesDown(PhosphorIconsStyle.regular),
        'arrow-fat-lines-left':
            PhosphorIcons.arrowFatLinesLeft(PhosphorIconsStyle.regular),
        'arrow-fat-lines-right':
            PhosphorIcons.arrowFatLinesRight(PhosphorIconsStyle.regular),
        'arrow-fat-lines-up':
            PhosphorIcons.arrowFatLinesUp(PhosphorIconsStyle.regular),
        'arrow-fat-line-up':
            PhosphorIcons.arrowFatLineUp(PhosphorIconsStyle.regular),
        'arrow-fat-right':
            PhosphorIcons.arrowFatRight(PhosphorIconsStyle.regular),
        'arrow-fat-up': PhosphorIcons.arrowFatUp(PhosphorIconsStyle.regular),
        'arrow-left': PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular),
        'arrow-line-down':
            PhosphorIcons.arrowLineDown(PhosphorIconsStyle.regular),
        'arrow-line-down-left':
            PhosphorIcons.arrowLineDownLeft(PhosphorIconsStyle.regular),
        'arrow-line-down-right':
            PhosphorIcons.arrowLineDownRight(PhosphorIconsStyle.regular),
        'arrow-line-left':
            PhosphorIcons.arrowLineLeft(PhosphorIconsStyle.regular),
        'arrow-line-right':
            PhosphorIcons.arrowLineRight(PhosphorIconsStyle.regular),
        'arrow-line-up': PhosphorIcons.arrowLineUp(PhosphorIconsStyle.regular),
        'arrow-line-up-left':
            PhosphorIcons.arrowLineUpLeft(PhosphorIconsStyle.regular),
        'arrow-line-up-right':
            PhosphorIcons.arrowLineUpRight(PhosphorIconsStyle.regular),
        'arrow-right': PhosphorIcons.arrowRight(PhosphorIconsStyle.regular),
        'arrows-clockwise':
            PhosphorIcons.arrowsClockwise(PhosphorIconsStyle.regular),
        'arrows-counter-clockwise':
            PhosphorIcons.arrowsCounterClockwise(PhosphorIconsStyle.regular),
        'arrows-down-up':
            PhosphorIcons.arrowsDownUp(PhosphorIconsStyle.regular),
        'arrows-horizontal':
            PhosphorIcons.arrowsHorizontal(PhosphorIconsStyle.regular),
        'arrows-in': PhosphorIcons.arrowsIn(PhosphorIconsStyle.regular),
        'arrows-in-cardinal':
            PhosphorIcons.arrowsInCardinal(PhosphorIconsStyle.regular),
        'arrows-in-line-horizontal':
            PhosphorIcons.arrowsInLineHorizontal(PhosphorIconsStyle.regular),
        'arrows-in-line-vertical':
            PhosphorIcons.arrowsInLineVertical(PhosphorIconsStyle.regular),
        'arrows-in-simple':
            PhosphorIcons.arrowsInSimple(PhosphorIconsStyle.regular),
        'arrows-left-right':
            PhosphorIcons.arrowsLeftRight(PhosphorIconsStyle.regular),
        'arrows-merge': PhosphorIcons.arrowsMerge(PhosphorIconsStyle.regular),
        'arrows-out': PhosphorIcons.arrowsOut(PhosphorIconsStyle.regular),
        'arrows-out-cardinal':
            PhosphorIcons.arrowsOutCardinal(PhosphorIconsStyle.regular),
        'arrows-out-line-horizontal':
            PhosphorIcons.arrowsOutLineHorizontal(PhosphorIconsStyle.regular),
        'arrows-out-line-vertical':
            PhosphorIcons.arrowsOutLineVertical(PhosphorIconsStyle.regular),
        'arrows-out-simple':
            PhosphorIcons.arrowsOutSimple(PhosphorIconsStyle.regular),
        'arrow-square-down':
            PhosphorIcons.arrowSquareDown(PhosphorIconsStyle.regular),
        'arrow-square-down-left':
            PhosphorIcons.arrowSquareDownLeft(PhosphorIconsStyle.regular),
        'arrow-square-down-right':
            PhosphorIcons.arrowSquareDownRight(PhosphorIconsStyle.regular),
        'arrow-square-in':
            PhosphorIcons.arrowSquareIn(PhosphorIconsStyle.regular),
        'arrow-square-left':
            PhosphorIcons.arrowSquareLeft(PhosphorIconsStyle.regular),
        'arrow-square-out':
            PhosphorIcons.arrowSquareOut(PhosphorIconsStyle.regular),
        'arrow-square-right':
            PhosphorIcons.arrowSquareRight(PhosphorIconsStyle.regular),
        'arrow-square-up':
            PhosphorIcons.arrowSquareUp(PhosphorIconsStyle.regular),
        'arrow-square-up-left':
            PhosphorIcons.arrowSquareUpLeft(PhosphorIconsStyle.regular),
        'arrow-square-up-right':
            PhosphorIcons.arrowSquareUpRight(PhosphorIconsStyle.regular),
        'arrows-split': PhosphorIcons.arrowsSplit(PhosphorIconsStyle.regular),
        'arrows-vertical':
            PhosphorIcons.arrowsVertical(PhosphorIconsStyle.regular),
        'arrow-u-down-left':
            PhosphorIcons.arrowUDownLeft(PhosphorIconsStyle.regular),
        'arrow-u-down-right':
            PhosphorIcons.arrowUDownRight(PhosphorIconsStyle.regular),
        'arrow-u-left-down':
            PhosphorIcons.arrowULeftDown(PhosphorIconsStyle.regular),
        'arrow-u-left-up':
            PhosphorIcons.arrowULeftUp(PhosphorIconsStyle.regular),
        'arrow-up': PhosphorIcons.arrowUp(PhosphorIconsStyle.regular),
        'arrow-up-left': PhosphorIcons.arrowUpLeft(PhosphorIconsStyle.regular),
        'arrow-up-right':
            PhosphorIcons.arrowUpRight(PhosphorIconsStyle.regular),
        'arrow-u-right-down':
            PhosphorIcons.arrowURightDown(PhosphorIconsStyle.regular),
        'arrow-u-right-up':
            PhosphorIcons.arrowURightUp(PhosphorIconsStyle.regular),
        'arrow-u-up-left':
            PhosphorIcons.arrowUUpLeft(PhosphorIconsStyle.regular),
        'arrow-u-up-right':
            PhosphorIcons.arrowUUpRight(PhosphorIconsStyle.regular),
        'article': PhosphorIcons.article(PhosphorIconsStyle.regular),
        'article-medium':
            PhosphorIcons.articleMedium(PhosphorIconsStyle.regular),
        'article-ny-times':
            PhosphorIcons.articleNyTimes(PhosphorIconsStyle.regular),
        'asterisk': PhosphorIcons.asterisk(PhosphorIconsStyle.regular),
        'asterisk-simple':
            PhosphorIcons.asteriskSimple(PhosphorIconsStyle.regular),
        'at': PhosphorIcons.at(PhosphorIconsStyle.regular),
        'atom': PhosphorIcons.atom(PhosphorIconsStyle.regular),
        'baby': PhosphorIcons.baby(PhosphorIconsStyle.regular),
        'backpack': PhosphorIcons.backpack(PhosphorIconsStyle.regular),
        'backspace': PhosphorIcons.backspace(PhosphorIconsStyle.regular),
        'bag': PhosphorIcons.bag(PhosphorIconsStyle.regular),
        'bag-simple': PhosphorIcons.bagSimple(PhosphorIconsStyle.regular),
        'balloon': PhosphorIcons.balloon(PhosphorIconsStyle.regular),
        'bandaids': PhosphorIcons.bandaids(PhosphorIconsStyle.regular),
        'bank': PhosphorIcons.bank(PhosphorIconsStyle.regular),
        'barbell': PhosphorIcons.barbell(PhosphorIconsStyle.regular),
        'barcode': PhosphorIcons.barcode(PhosphorIconsStyle.regular),
        'barricade': PhosphorIcons.barricade(PhosphorIconsStyle.regular),
        'baseball': PhosphorIcons.baseball(PhosphorIconsStyle.regular),
        'baseball-cap': PhosphorIcons.baseballCap(PhosphorIconsStyle.regular),
        'basket': PhosphorIcons.basket(PhosphorIconsStyle.regular),
        'basketball': PhosphorIcons.basketball(PhosphorIconsStyle.regular),
        'bathtub': PhosphorIcons.bathtub(PhosphorIconsStyle.regular),
        'battery-charging':
            PhosphorIcons.batteryCharging(PhosphorIconsStyle.regular),
        'battery-charging-vertical':
            PhosphorIcons.batteryChargingVertical(PhosphorIconsStyle.regular),
        'battery-empty': PhosphorIcons.batteryEmpty(PhosphorIconsStyle.regular),
        'battery-full': PhosphorIcons.batteryFull(PhosphorIconsStyle.regular),
        'battery-high': PhosphorIcons.batteryHigh(PhosphorIconsStyle.regular),
        'battery-low': PhosphorIcons.batteryLow(PhosphorIconsStyle.regular),
        'battery-medium':
            PhosphorIcons.batteryMedium(PhosphorIconsStyle.regular),
        'battery-plus': PhosphorIcons.batteryPlus(PhosphorIconsStyle.regular),
        'battery-plus-vertical':
            PhosphorIcons.batteryPlusVertical(PhosphorIconsStyle.regular),
        'battery-vertical-empty':
            PhosphorIcons.batteryVerticalEmpty(PhosphorIconsStyle.regular),
        'battery-vertical-full':
            PhosphorIcons.batteryVerticalFull(PhosphorIconsStyle.regular),
        'battery-vertical-high':
            PhosphorIcons.batteryVerticalHigh(PhosphorIconsStyle.regular),
        'battery-vertical-low':
            PhosphorIcons.batteryVerticalLow(PhosphorIconsStyle.regular),
        'battery-vertical-medium':
            PhosphorIcons.batteryVerticalMedium(PhosphorIconsStyle.regular),
        'battery-warning':
            PhosphorIcons.batteryWarning(PhosphorIconsStyle.regular),
        'battery-warning-vertical':
            PhosphorIcons.batteryWarningVertical(PhosphorIconsStyle.regular),
        'bed': PhosphorIcons.bed(PhosphorIconsStyle.regular),
        'beer-bottle': PhosphorIcons.beerBottle(PhosphorIconsStyle.regular),
        'beer-stein': PhosphorIcons.beerStein(PhosphorIconsStyle.regular),
        'behance-logo': PhosphorIcons.behanceLogo(PhosphorIconsStyle.regular),
        'bell': PhosphorIcons.bell(PhosphorIconsStyle.regular),
        'bell-ringing': PhosphorIcons.bellRinging(PhosphorIconsStyle.regular),
        'bell-simple': PhosphorIcons.bellSimple(PhosphorIconsStyle.regular),
        'bell-simple-ringing':
            PhosphorIcons.bellSimpleRinging(PhosphorIconsStyle.regular),
        'bell-simple-slash':
            PhosphorIcons.bellSimpleSlash(PhosphorIconsStyle.regular),
        'bell-simple-z': PhosphorIcons.bellSimpleZ(PhosphorIconsStyle.regular),
        'bell-slash': PhosphorIcons.bellSlash(PhosphorIconsStyle.regular),
        'bell-z': PhosphorIcons.bellZ(PhosphorIconsStyle.regular),
        'bezier-curve': PhosphorIcons.bezierCurve(PhosphorIconsStyle.regular),
        'bicycle': PhosphorIcons.bicycle(PhosphorIconsStyle.regular),
        'binoculars': PhosphorIcons.binoculars(PhosphorIconsStyle.regular),
        'bird': PhosphorIcons.bird(PhosphorIconsStyle.regular),
        'bluetooth': PhosphorIcons.bluetooth(PhosphorIconsStyle.regular),
        'bluetooth-connected':
            PhosphorIcons.bluetoothConnected(PhosphorIconsStyle.regular),
        'bluetooth-slash':
            PhosphorIcons.bluetoothSlash(PhosphorIconsStyle.regular),
        'bluetooth-x': PhosphorIcons.bluetoothX(PhosphorIconsStyle.regular),
        'boat': PhosphorIcons.boat(PhosphorIconsStyle.regular),
        'bone': PhosphorIcons.bone(PhosphorIconsStyle.regular),
        'book': PhosphorIcons.book(PhosphorIconsStyle.regular),
        'book-bookmark': PhosphorIcons.bookBookmark(PhosphorIconsStyle.regular),
        'bookmark': PhosphorIcons.bookmark(PhosphorIconsStyle.regular),
        'bookmarks': PhosphorIcons.bookmarks(PhosphorIconsStyle.regular),
        'bookmark-simple':
            PhosphorIcons.bookmarkSimple(PhosphorIconsStyle.regular),
        'bookmarks-simple':
            PhosphorIcons.bookmarksSimple(PhosphorIconsStyle.regular),
        'book-open': PhosphorIcons.bookOpen(PhosphorIconsStyle.regular),
        'book-open-text':
            PhosphorIcons.bookOpenText(PhosphorIconsStyle.regular),
        'books': PhosphorIcons.books(PhosphorIconsStyle.regular),
        'boot': PhosphorIcons.boot(PhosphorIconsStyle.regular),
        'bounding-box': PhosphorIcons.boundingBox(PhosphorIconsStyle.regular),
        'bowl-food': PhosphorIcons.bowlFood(PhosphorIconsStyle.regular),
        'brackets-angle':
            PhosphorIcons.bracketsAngle(PhosphorIconsStyle.regular),
        'brackets-curly':
            PhosphorIcons.bracketsCurly(PhosphorIconsStyle.regular),
        'brackets-round':
            PhosphorIcons.bracketsRound(PhosphorIconsStyle.regular),
        'brackets-square':
            PhosphorIcons.bracketsSquare(PhosphorIconsStyle.regular),
        'brain': PhosphorIcons.brain(PhosphorIconsStyle.regular),
        'brandy': PhosphorIcons.brandy(PhosphorIconsStyle.regular),
        'bridge': PhosphorIcons.bridge(PhosphorIconsStyle.regular),
        'briefcase': PhosphorIcons.briefcase(PhosphorIconsStyle.regular),
        'briefcase-metal':
            PhosphorIcons.briefcaseMetal(PhosphorIconsStyle.regular),
        'broadcast': PhosphorIcons.broadcast(PhosphorIconsStyle.regular),
        'broom': PhosphorIcons.broom(PhosphorIconsStyle.regular),
        'browser': PhosphorIcons.browser(PhosphorIconsStyle.regular),
        'browsers': PhosphorIcons.browsers(PhosphorIconsStyle.regular),
        'bug': PhosphorIcons.bug(PhosphorIconsStyle.regular),
        'bug-beetle': PhosphorIcons.bugBeetle(PhosphorIconsStyle.regular),
        'bug-droid': PhosphorIcons.bugDroid(PhosphorIconsStyle.regular),
        'buildings': PhosphorIcons.buildings(PhosphorIconsStyle.regular),
        'bus': PhosphorIcons.bus(PhosphorIconsStyle.regular),
        'butterfly': PhosphorIcons.butterfly(PhosphorIconsStyle.regular),
        'cactus': PhosphorIcons.cactus(PhosphorIconsStyle.regular),
        'cake': PhosphorIcons.cake(PhosphorIconsStyle.regular),
        'calculator': PhosphorIcons.calculator(PhosphorIconsStyle.regular),
        'calendar': PhosphorIcons.calendar(PhosphorIconsStyle.regular),
        'calendar-blank':
            PhosphorIcons.calendarBlank(PhosphorIconsStyle.regular),
        'calendar-check':
            PhosphorIcons.calendarCheck(PhosphorIconsStyle.regular),
        'calendar-plus': PhosphorIcons.calendarPlus(PhosphorIconsStyle.regular),
        'calendar-x': PhosphorIcons.calendarX(PhosphorIconsStyle.regular),
        'call-bell': PhosphorIcons.callBell(PhosphorIconsStyle.regular),
        'camera': PhosphorIcons.camera(PhosphorIconsStyle.regular),
        'camera-plus': PhosphorIcons.cameraPlus(PhosphorIconsStyle.regular),
        'camera-rotate': PhosphorIcons.cameraRotate(PhosphorIconsStyle.regular),
        'camera-slash': PhosphorIcons.cameraSlash(PhosphorIconsStyle.regular),
        'campfire': PhosphorIcons.campfire(PhosphorIconsStyle.regular),
        'car': PhosphorIcons.car(PhosphorIconsStyle.regular),
        'cardholder': PhosphorIcons.cardholder(PhosphorIconsStyle.regular),
        'cards': PhosphorIcons.cards(PhosphorIconsStyle.regular),
        'caret-circle-double-down':
            PhosphorIcons.caretCircleDoubleDown(PhosphorIconsStyle.regular),
        'caret-circle-double-left':
            PhosphorIcons.caretCircleDoubleLeft(PhosphorIconsStyle.regular),
        'caret-circle-double-right':
            PhosphorIcons.caretCircleDoubleRight(PhosphorIconsStyle.regular),
        'caret-circle-double-up':
            PhosphorIcons.caretCircleDoubleUp(PhosphorIconsStyle.regular),
        'caret-circle-down':
            PhosphorIcons.caretCircleDown(PhosphorIconsStyle.regular),
        'caret-circle-left':
            PhosphorIcons.caretCircleLeft(PhosphorIconsStyle.regular),
        'caret-circle-right':
            PhosphorIcons.caretCircleRight(PhosphorIconsStyle.regular),
        'caret-circle-up':
            PhosphorIcons.caretCircleUp(PhosphorIconsStyle.regular),
        'caret-circle-up-down':
            PhosphorIcons.caretCircleUpDown(PhosphorIconsStyle.regular),
        'caret-double-down':
            PhosphorIcons.caretDoubleDown(PhosphorIconsStyle.regular),
        'caret-double-left':
            PhosphorIcons.caretDoubleLeft(PhosphorIconsStyle.regular),
        'caret-double-right':
            PhosphorIcons.caretDoubleRight(PhosphorIconsStyle.regular),
        'caret-double-up':
            PhosphorIcons.caretDoubleUp(PhosphorIconsStyle.regular),
        'caret-down': PhosphorIcons.caretDown(PhosphorIconsStyle.regular),
        'caret-left': PhosphorIcons.caretLeft(PhosphorIconsStyle.regular),
        'caret-right': PhosphorIcons.caretRight(PhosphorIconsStyle.regular),
        'caret-up': PhosphorIcons.caretUp(PhosphorIconsStyle.regular),
        'caret-up-down': PhosphorIcons.caretUpDown(PhosphorIconsStyle.regular),
        'car-profile': PhosphorIcons.carProfile(PhosphorIconsStyle.regular),
        'carrot': PhosphorIcons.carrot(PhosphorIconsStyle.regular),
        'car-simple': PhosphorIcons.carSimple(PhosphorIconsStyle.regular),
        'cassette-tape': PhosphorIcons.cassetteTape(PhosphorIconsStyle.regular),
        'castle-turret': PhosphorIcons.castleTurret(PhosphorIconsStyle.regular),
        'cat': PhosphorIcons.cat(PhosphorIconsStyle.regular),
        'cell-signal-full':
            PhosphorIcons.cellSignalFull(PhosphorIconsStyle.regular),
        'cell-signal-high':
            PhosphorIcons.cellSignalHigh(PhosphorIconsStyle.regular),
        'cell-signal-low':
            PhosphorIcons.cellSignalLow(PhosphorIconsStyle.regular),
        'cell-signal-medium':
            PhosphorIcons.cellSignalMedium(PhosphorIconsStyle.regular),
        'cell-signal-none':
            PhosphorIcons.cellSignalNone(PhosphorIconsStyle.regular),
        'cell-signal-slash':
            PhosphorIcons.cellSignalSlash(PhosphorIconsStyle.regular),
        'cell-signal-x': PhosphorIcons.cellSignalX(PhosphorIconsStyle.regular),
        'certificate': PhosphorIcons.certificate(PhosphorIconsStyle.regular),
        'chair': PhosphorIcons.chair(PhosphorIconsStyle.regular),
        'chalkboard': PhosphorIcons.chalkboard(PhosphorIconsStyle.regular),
        'chalkboard-simple':
            PhosphorIcons.chalkboardSimple(PhosphorIconsStyle.regular),
        'chalkboard-teacher':
            PhosphorIcons.chalkboardTeacher(PhosphorIconsStyle.regular),
        'champagne': PhosphorIcons.champagne(PhosphorIconsStyle.regular),
        'charging-station':
            PhosphorIcons.chargingStation(PhosphorIconsStyle.regular),
        'chart-bar': PhosphorIcons.chartBar(PhosphorIconsStyle.regular),
        'chart-bar-horizontal':
            PhosphorIcons.chartBarHorizontal(PhosphorIconsStyle.regular),
        'chart-donut': PhosphorIcons.chartDonut(PhosphorIconsStyle.regular),
        'chart-line': PhosphorIcons.chartLine(PhosphorIconsStyle.regular),
        'chart-line-down':
            PhosphorIcons.chartLineDown(PhosphorIconsStyle.regular),
        'chart-line-up': PhosphorIcons.chartLineUp(PhosphorIconsStyle.regular),
        'chart-pie': PhosphorIcons.chartPie(PhosphorIconsStyle.regular),
        'chart-pie-slice':
            PhosphorIcons.chartPieSlice(PhosphorIconsStyle.regular),
        'chart-polar': PhosphorIcons.chartPolar(PhosphorIconsStyle.regular),
        'chart-scatter': PhosphorIcons.chartScatter(PhosphorIconsStyle.regular),
        'chat': PhosphorIcons.chat(PhosphorIconsStyle.regular),
        'chat-centered': PhosphorIcons.chatCentered(PhosphorIconsStyle.regular),
        'chat-centered-dots':
            PhosphorIcons.chatCenteredDots(PhosphorIconsStyle.regular),
        'chat-centered-text':
            PhosphorIcons.chatCenteredText(PhosphorIconsStyle.regular),
        'chat-circle': PhosphorIcons.chatCircle(PhosphorIconsStyle.regular),
        'chat-circle-dots':
            PhosphorIcons.chatCircleDots(PhosphorIconsStyle.regular),
        'chat-circle-text':
            PhosphorIcons.chatCircleText(PhosphorIconsStyle.regular),
        'chat-dots': PhosphorIcons.chatDots(PhosphorIconsStyle.regular),
        'chats': PhosphorIcons.chats(PhosphorIconsStyle.regular),
        'chats-circle': PhosphorIcons.chatsCircle(PhosphorIconsStyle.regular),
        'chats-teardrop':
            PhosphorIcons.chatsTeardrop(PhosphorIconsStyle.regular),
        'chat-teardrop': PhosphorIcons.chatTeardrop(PhosphorIconsStyle.regular),
        'chat-teardrop-dots':
            PhosphorIcons.chatTeardropDots(PhosphorIconsStyle.regular),
        'chat-teardrop-text':
            PhosphorIcons.chatTeardropText(PhosphorIconsStyle.regular),
        'chat-text': PhosphorIcons.chatText(PhosphorIconsStyle.regular),
        'check': PhosphorIcons.check(PhosphorIconsStyle.regular),
        'check-circle': PhosphorIcons.checkCircle(PhosphorIconsStyle.regular),
        'check-fat': PhosphorIcons.checkFat(PhosphorIconsStyle.regular),
        'checks': PhosphorIcons.checks(PhosphorIconsStyle.regular),
        'check-square': PhosphorIcons.checkSquare(PhosphorIconsStyle.regular),
        'check-square-offset':
            PhosphorIcons.checkSquareOffset(PhosphorIconsStyle.regular),
        'church': PhosphorIcons.church(PhosphorIconsStyle.regular),
        'circle': PhosphorIcons.circle(PhosphorIconsStyle.regular),
        'circle-dashed': PhosphorIcons.circleDashed(PhosphorIconsStyle.regular),
        'circle-half': PhosphorIcons.circleHalf(PhosphorIconsStyle.regular),
        'circle-half-tilt':
            PhosphorIcons.circleHalfTilt(PhosphorIconsStyle.regular),
        'circle-notch': PhosphorIcons.circleNotch(PhosphorIconsStyle.regular),
        'circles-four': PhosphorIcons.circlesFour(PhosphorIconsStyle.regular),
        'circles-three': PhosphorIcons.circlesThree(PhosphorIconsStyle.regular),
        'circles-three-plus':
            PhosphorIcons.circlesThreePlus(PhosphorIconsStyle.regular),
        'circuitry': PhosphorIcons.circuitry(PhosphorIconsStyle.regular),
        'clipboard': PhosphorIcons.clipboard(PhosphorIconsStyle.regular),
        'clipboard-text':
            PhosphorIcons.clipboardText(PhosphorIconsStyle.regular),
        'clock': PhosphorIcons.clock(PhosphorIconsStyle.regular),
        'clock-afternoon':
            PhosphorIcons.clockAfternoon(PhosphorIconsStyle.regular),
        'clock-clockwise':
            PhosphorIcons.clockClockwise(PhosphorIconsStyle.regular),
        'clock-countdown':
            PhosphorIcons.clockCountdown(PhosphorIconsStyle.regular),
        'clock-counter-clockwise':
            PhosphorIcons.clockCounterClockwise(PhosphorIconsStyle.regular),
        'closed-captioning':
            PhosphorIcons.closedCaptioning(PhosphorIconsStyle.regular),
        'cloud': PhosphorIcons.cloud(PhosphorIconsStyle.regular),
        'cloud-arrow-down':
            PhosphorIcons.cloudArrowDown(PhosphorIconsStyle.regular),
        'cloud-arrow-up':
            PhosphorIcons.cloudArrowUp(PhosphorIconsStyle.regular),
        'cloud-check': PhosphorIcons.cloudCheck(PhosphorIconsStyle.regular),
        'cloud-fog': PhosphorIcons.cloudFog(PhosphorIconsStyle.regular),
        'cloud-lightning':
            PhosphorIcons.cloudLightning(PhosphorIconsStyle.regular),
        'cloud-moon': PhosphorIcons.cloudMoon(PhosphorIconsStyle.regular),
        'cloud-rain': PhosphorIcons.cloudRain(PhosphorIconsStyle.regular),
        'cloud-slash': PhosphorIcons.cloudSlash(PhosphorIconsStyle.regular),
        'cloud-snow': PhosphorIcons.cloudSnow(PhosphorIconsStyle.regular),
        'cloud-sun': PhosphorIcons.cloudSun(PhosphorIconsStyle.regular),
        'cloud-warning': PhosphorIcons.cloudWarning(PhosphorIconsStyle.regular),
        'cloud-x': PhosphorIcons.cloudX(PhosphorIconsStyle.regular),
        'club': PhosphorIcons.club(PhosphorIconsStyle.regular),
        'coat-hanger': PhosphorIcons.coatHanger(PhosphorIconsStyle.regular),
        'coda-logo': PhosphorIcons.codaLogo(PhosphorIconsStyle.regular),
        'code': PhosphorIcons.code(PhosphorIconsStyle.regular),
        'code-block': PhosphorIcons.codeBlock(PhosphorIconsStyle.regular),
        'codepen-logo': PhosphorIcons.codepenLogo(PhosphorIconsStyle.regular),
        'codesandbox-logo':
            PhosphorIcons.codesandboxLogo(PhosphorIconsStyle.regular),
        'code-simple': PhosphorIcons.codeSimple(PhosphorIconsStyle.regular),
        'coffee': PhosphorIcons.coffee(PhosphorIconsStyle.regular),
        'coin': PhosphorIcons.coin(PhosphorIconsStyle.regular),
        'coins': PhosphorIcons.coins(PhosphorIconsStyle.regular),
        'coin-vertical': PhosphorIcons.coinVertical(PhosphorIconsStyle.regular),
        'columns': PhosphorIcons.columns(PhosphorIconsStyle.regular),
        'command': PhosphorIcons.command(PhosphorIconsStyle.regular),
        'compass': PhosphorIcons.compass(PhosphorIconsStyle.regular),
        'compass-tool': PhosphorIcons.compassTool(PhosphorIconsStyle.regular),
        'computer-tower':
            PhosphorIcons.computerTower(PhosphorIconsStyle.regular),
        'confetti': PhosphorIcons.confetti(PhosphorIconsStyle.regular),
        'contactless-payment':
            PhosphorIcons.contactlessPayment(PhosphorIconsStyle.regular),
        'control': PhosphorIcons.control(PhosphorIconsStyle.regular),
        'cookie': PhosphorIcons.cookie(PhosphorIconsStyle.regular),
        'cooking-pot': PhosphorIcons.cookingPot(PhosphorIconsStyle.regular),
        'copy': PhosphorIcons.copy(PhosphorIconsStyle.regular),
        'copyleft': PhosphorIcons.copyleft(PhosphorIconsStyle.regular),
        'copyright': PhosphorIcons.copyright(PhosphorIconsStyle.regular),
        'copy-simple': PhosphorIcons.copySimple(PhosphorIconsStyle.regular),
        'corners-in': PhosphorIcons.cornersIn(PhosphorIconsStyle.regular),
        'corners-out': PhosphorIcons.cornersOut(PhosphorIconsStyle.regular),
        'couch': PhosphorIcons.couch(PhosphorIconsStyle.regular),
        'cpu': PhosphorIcons.cpu(PhosphorIconsStyle.regular),
        'credit-card': PhosphorIcons.creditCard(PhosphorIconsStyle.regular),
        'crop': PhosphorIcons.crop(PhosphorIconsStyle.regular),
        'cross': PhosphorIcons.cross(PhosphorIconsStyle.regular),
        'crosshair': PhosphorIcons.crosshair(PhosphorIconsStyle.regular),
        'crosshair-simple':
            PhosphorIcons.crosshairSimple(PhosphorIconsStyle.regular),
        'crown': PhosphorIcons.crown(PhosphorIconsStyle.regular),
        'crown-simple': PhosphorIcons.crownSimple(PhosphorIconsStyle.regular),
        'cube': PhosphorIcons.cube(PhosphorIconsStyle.regular),
        'cube-focus': PhosphorIcons.cubeFocus(PhosphorIconsStyle.regular),
        'cube-transparent':
            PhosphorIcons.cubeTransparent(PhosphorIconsStyle.regular),
        'currency-btc': PhosphorIcons.currencyBtc(PhosphorIconsStyle.regular),
        'currency-circle-dollar':
            PhosphorIcons.currencyCircleDollar(PhosphorIconsStyle.regular),
        'currency-cny': PhosphorIcons.currencyCny(PhosphorIconsStyle.regular),
        'currency-dollar':
            PhosphorIcons.currencyDollar(PhosphorIconsStyle.regular),
        'currency-dollar-simple':
            PhosphorIcons.currencyDollarSimple(PhosphorIconsStyle.regular),
        'currency-eth': PhosphorIcons.currencyEth(PhosphorIconsStyle.regular),
        'currency-eur': PhosphorIcons.currencyEur(PhosphorIconsStyle.regular),
        'currency-gbp': PhosphorIcons.currencyGbp(PhosphorIconsStyle.regular),
        'currency-inr': PhosphorIcons.currencyInr(PhosphorIconsStyle.regular),
        'currency-jpy': PhosphorIcons.currencyJpy(PhosphorIconsStyle.regular),
        'currency-krw': PhosphorIcons.currencyKrw(PhosphorIconsStyle.regular),
        'currency-kzt': PhosphorIcons.currencyKzt(PhosphorIconsStyle.regular),
        'currency-ngn': PhosphorIcons.currencyNgn(PhosphorIconsStyle.regular),
        'currency-rub': PhosphorIcons.currencyRub(PhosphorIconsStyle.regular),
        'cursor': PhosphorIcons.cursor(PhosphorIconsStyle.regular),
        'cursor-click': PhosphorIcons.cursorClick(PhosphorIconsStyle.regular),
        'cursor-text': PhosphorIcons.cursorText(PhosphorIconsStyle.regular),
        'cylinder': PhosphorIcons.cylinder(PhosphorIconsStyle.regular),
        'database': PhosphorIcons.database(PhosphorIconsStyle.regular),
        'desktop': PhosphorIcons.desktop(PhosphorIconsStyle.regular),
        'desktop-tower': PhosphorIcons.desktopTower(PhosphorIconsStyle.regular),
        'detective': PhosphorIcons.detective(PhosphorIconsStyle.regular),
        'device-mobile': PhosphorIcons.deviceMobile(PhosphorIconsStyle.regular),
        'device-mobile-camera':
            PhosphorIcons.deviceMobileCamera(PhosphorIconsStyle.regular),
        'device-mobile-speaker':
            PhosphorIcons.deviceMobileSpeaker(PhosphorIconsStyle.regular),
        'devices': PhosphorIcons.devices(PhosphorIconsStyle.regular),
        'device-tablet': PhosphorIcons.deviceTablet(PhosphorIconsStyle.regular),
        'device-tablet-camera':
            PhosphorIcons.deviceTabletCamera(PhosphorIconsStyle.regular),
        'device-tablet-speaker':
            PhosphorIcons.deviceTabletSpeaker(PhosphorIconsStyle.regular),
        'dev-to-logo': PhosphorIcons.devToLogo(PhosphorIconsStyle.regular),
        'diamond': PhosphorIcons.diamond(PhosphorIconsStyle.regular),
        'diamonds-four': PhosphorIcons.diamondsFour(PhosphorIconsStyle.regular),
        'dice-five': PhosphorIcons.diceFive(PhosphorIconsStyle.regular),
        'dice-four': PhosphorIcons.diceFour(PhosphorIconsStyle.regular),
        'dice-one': PhosphorIcons.diceOne(PhosphorIconsStyle.regular),
        'dice-six': PhosphorIcons.diceSix(PhosphorIconsStyle.regular),
        'dice-three': PhosphorIcons.diceThree(PhosphorIconsStyle.regular),
        'dice-two': PhosphorIcons.diceTwo(PhosphorIconsStyle.regular),
        'disc': PhosphorIcons.disc(PhosphorIconsStyle.regular),
        'discord-logo': PhosphorIcons.discordLogo(PhosphorIconsStyle.regular),
        'divide': PhosphorIcons.divide(PhosphorIconsStyle.regular),
        'dna': PhosphorIcons.dna(PhosphorIconsStyle.regular),
        'dog': PhosphorIcons.dog(PhosphorIconsStyle.regular),
        'door': PhosphorIcons.door(PhosphorIconsStyle.regular),
        'door-open': PhosphorIcons.doorOpen(PhosphorIconsStyle.regular),
        'dot': PhosphorIcons.dot(PhosphorIconsStyle.regular),
        'dot-outline': PhosphorIcons.dotOutline(PhosphorIconsStyle.regular),
        'dots-nine': PhosphorIcons.dotsNine(PhosphorIconsStyle.regular),
        'dots-six': PhosphorIcons.dotsSix(PhosphorIconsStyle.regular),
        'dots-six-vertical':
            PhosphorIcons.dotsSixVertical(PhosphorIconsStyle.regular),
        'dots-three': PhosphorIcons.dotsThree(PhosphorIconsStyle.regular),
        'dots-three-circle':
            PhosphorIcons.dotsThreeCircle(PhosphorIconsStyle.regular),
        'dots-three-circle-vertical':
            PhosphorIcons.dotsThreeCircleVertical(PhosphorIconsStyle.regular),
        'dots-three-outline':
            PhosphorIcons.dotsThreeOutline(PhosphorIconsStyle.regular),
        'dots-three-outline-vertical':
            PhosphorIcons.dotsThreeOutlineVertical(PhosphorIconsStyle.regular),
        'dots-three-vertical':
            PhosphorIcons.dotsThreeVertical(PhosphorIconsStyle.regular),
        'download': PhosphorIcons.download(PhosphorIconsStyle.regular),
        'download-simple':
            PhosphorIcons.downloadSimple(PhosphorIconsStyle.regular),
        'dress': PhosphorIcons.dress(PhosphorIconsStyle.regular),
        'dribbble-logo': PhosphorIcons.dribbbleLogo(PhosphorIconsStyle.regular),
        'drop': PhosphorIcons.drop(PhosphorIconsStyle.regular),
        'dropbox-logo': PhosphorIcons.dropboxLogo(PhosphorIconsStyle.regular),
        'drop-half': PhosphorIcons.dropHalf(PhosphorIconsStyle.regular),
        'drop-half-bottom':
            PhosphorIcons.dropHalfBottom(PhosphorIconsStyle.regular),
        'ear': PhosphorIcons.ear(PhosphorIconsStyle.regular),
        'ear-slash': PhosphorIcons.earSlash(PhosphorIconsStyle.regular),
        'egg': PhosphorIcons.egg(PhosphorIconsStyle.regular),
        'egg-crack': PhosphorIcons.eggCrack(PhosphorIconsStyle.regular),
        'eject': PhosphorIcons.eject(PhosphorIconsStyle.regular),
        'eject-simple': PhosphorIcons.ejectSimple(PhosphorIconsStyle.regular),
        'elevator': PhosphorIcons.elevator(PhosphorIconsStyle.regular),
        'engine': PhosphorIcons.engine(PhosphorIconsStyle.regular),
        'envelope': PhosphorIcons.envelope(PhosphorIconsStyle.regular),
        'envelope-open': PhosphorIcons.envelopeOpen(PhosphorIconsStyle.regular),
        'envelope-simple':
            PhosphorIcons.envelopeSimple(PhosphorIconsStyle.regular),
        'envelope-simple-open':
            PhosphorIcons.envelopeSimpleOpen(PhosphorIconsStyle.regular),
        'equalizer': PhosphorIcons.equalizer(PhosphorIconsStyle.regular),
        'equals': PhosphorIcons.equals(PhosphorIconsStyle.regular),
        'eraser': PhosphorIcons.eraser(PhosphorIconsStyle.regular),
        'escalator-down':
            PhosphorIcons.escalatorDown(PhosphorIconsStyle.regular),
        'escalator-up': PhosphorIcons.escalatorUp(PhosphorIconsStyle.regular),
        'exam': PhosphorIcons.exam(PhosphorIconsStyle.regular),
        'exclude': PhosphorIcons.exclude(PhosphorIconsStyle.regular),
        'exclude-square':
            PhosphorIcons.excludeSquare(PhosphorIconsStyle.regular),
        'export': PhosphorIcons.export(PhosphorIconsStyle.regular),
        'eye': PhosphorIcons.eye(PhosphorIconsStyle.regular),
        'eye-closed': PhosphorIcons.eyeClosed(PhosphorIconsStyle.regular),
        'eyedropper': PhosphorIcons.eyedropper(PhosphorIconsStyle.regular),
        'eyedropper-sample':
            PhosphorIcons.eyedropperSample(PhosphorIconsStyle.regular),
        'eyeglasses': PhosphorIcons.eyeglasses(PhosphorIconsStyle.regular),
        'eye-slash': PhosphorIcons.eyeSlash(PhosphorIconsStyle.regular),
        'facebook-logo': PhosphorIcons.facebookLogo(PhosphorIconsStyle.regular),
        'face-mask': PhosphorIcons.faceMask(PhosphorIconsStyle.regular),
        'factory': PhosphorIcons.factory(PhosphorIconsStyle.regular),
        'faders': PhosphorIcons.faders(PhosphorIconsStyle.regular),
        'faders-horizontal':
            PhosphorIcons.fadersHorizontal(PhosphorIconsStyle.regular),
        'fan': PhosphorIcons.fan(PhosphorIconsStyle.regular),
        'fast-forward': PhosphorIcons.fastForward(PhosphorIconsStyle.regular),
        'fast-forward-circle':
            PhosphorIcons.fastForwardCircle(PhosphorIconsStyle.regular),
        'feather': PhosphorIcons.feather(PhosphorIconsStyle.regular),
        'figma-logo': PhosphorIcons.figmaLogo(PhosphorIconsStyle.regular),
        'file': PhosphorIcons.file(PhosphorIconsStyle.regular),
        'file-archive': PhosphorIcons.fileArchive(PhosphorIconsStyle.regular),
        'file-arrow-down':
            PhosphorIcons.fileArrowDown(PhosphorIconsStyle.regular),
        'file-arrow-up': PhosphorIcons.fileArrowUp(PhosphorIconsStyle.regular),
        'file-audio': PhosphorIcons.fileAudio(PhosphorIconsStyle.regular),
        'file-cloud': PhosphorIcons.fileCloud(PhosphorIconsStyle.regular),
        'file-code': PhosphorIcons.fileCode(PhosphorIconsStyle.regular),
        'file-css': PhosphorIcons.fileCss(PhosphorIconsStyle.regular),
        'file-csv': PhosphorIcons.fileCsv(PhosphorIconsStyle.regular),
        'file-dashed': PhosphorIcons.fileDashed(PhosphorIconsStyle.regular),
        'file-doc': PhosphorIcons.fileDoc(PhosphorIconsStyle.regular),
        'file-html': PhosphorIcons.fileHtml(PhosphorIconsStyle.regular),
        'file-image': PhosphorIcons.fileImage(PhosphorIconsStyle.regular),
        'file-jpg': PhosphorIcons.fileJpg(PhosphorIconsStyle.regular),
        'file-js': PhosphorIcons.fileJs(PhosphorIconsStyle.regular),
        'file-jsx': PhosphorIcons.fileJsx(PhosphorIconsStyle.regular),
        'file-lock': PhosphorIcons.fileLock(PhosphorIconsStyle.regular),
        'file-magnifying-glass':
            PhosphorIcons.fileMagnifyingGlass(PhosphorIconsStyle.regular),
        'file-minus': PhosphorIcons.fileMinus(PhosphorIconsStyle.regular),
        'file-pdf': PhosphorIcons.filePdf(PhosphorIconsStyle.regular),
        'file-plus': PhosphorIcons.filePlus(PhosphorIconsStyle.regular),
        'file-png': PhosphorIcons.filePng(PhosphorIconsStyle.regular),
        'file-ppt': PhosphorIcons.filePpt(PhosphorIconsStyle.regular),
        'file-rs': PhosphorIcons.fileRs(PhosphorIconsStyle.regular),
        'files': PhosphorIcons.files(PhosphorIconsStyle.regular),
        'file-sql': PhosphorIcons.fileSql(PhosphorIconsStyle.regular),
        'file-svg': PhosphorIcons.fileSvg(PhosphorIconsStyle.regular),
        'file-text': PhosphorIcons.fileText(PhosphorIconsStyle.regular),
        'file-ts': PhosphorIcons.fileTs(PhosphorIconsStyle.regular),
        'file-tsx': PhosphorIcons.fileTsx(PhosphorIconsStyle.regular),
        'file-video': PhosphorIcons.fileVideo(PhosphorIconsStyle.regular),
        'file-vue': PhosphorIcons.fileVue(PhosphorIconsStyle.regular),
        'file-x': PhosphorIcons.fileX(PhosphorIconsStyle.regular),
        'file-xls': PhosphorIcons.fileXls(PhosphorIconsStyle.regular),
        'file-zip': PhosphorIcons.fileZip(PhosphorIconsStyle.regular),
        'film-reel': PhosphorIcons.filmReel(PhosphorIconsStyle.regular),
        'film-script': PhosphorIcons.filmScript(PhosphorIconsStyle.regular),
        'film-slate': PhosphorIcons.filmSlate(PhosphorIconsStyle.regular),
        'film-strip': PhosphorIcons.filmStrip(PhosphorIconsStyle.regular),
        'fingerprint': PhosphorIcons.fingerprint(PhosphorIconsStyle.regular),
        'fingerprint-simple':
            PhosphorIcons.fingerprintSimple(PhosphorIconsStyle.regular),
        'finn-the-human':
            PhosphorIcons.finnTheHuman(PhosphorIconsStyle.regular),
        'fire': PhosphorIcons.fire(PhosphorIconsStyle.regular),
        'fire-extinguisher':
            PhosphorIcons.fireExtinguisher(PhosphorIconsStyle.regular),
        'fire-simple': PhosphorIcons.fireSimple(PhosphorIconsStyle.regular),
        'first-aid': PhosphorIcons.firstAid(PhosphorIconsStyle.regular),
        'first-aid-kit': PhosphorIcons.firstAidKit(PhosphorIconsStyle.regular),
        'fish': PhosphorIcons.fish(PhosphorIconsStyle.regular),
        'fish-simple': PhosphorIcons.fishSimple(PhosphorIconsStyle.regular),
        'flag': PhosphorIcons.flag(PhosphorIconsStyle.regular),
        'flag-banner': PhosphorIcons.flagBanner(PhosphorIconsStyle.regular),
        'flag-checkered':
            PhosphorIcons.flagCheckered(PhosphorIconsStyle.regular),
        'flag-pennant': PhosphorIcons.flagPennant(PhosphorIconsStyle.regular),
        'flame': PhosphorIcons.flame(PhosphorIconsStyle.regular),
        'flashlight': PhosphorIcons.flashlight(PhosphorIconsStyle.regular),
        'flask': PhosphorIcons.flask(PhosphorIconsStyle.regular),
        'floppy-disk': PhosphorIcons.floppyDisk(PhosphorIconsStyle.regular),
        'floppy-disk-back':
            PhosphorIcons.floppyDiskBack(PhosphorIconsStyle.regular),
        'flow-arrow': PhosphorIcons.flowArrow(PhosphorIconsStyle.regular),
        'flower': PhosphorIcons.flower(PhosphorIconsStyle.regular),
        'flower-lotus': PhosphorIcons.flowerLotus(PhosphorIconsStyle.regular),
        'flower-tulip': PhosphorIcons.flowerTulip(PhosphorIconsStyle.regular),
        'flying-saucer': PhosphorIcons.flyingSaucer(PhosphorIconsStyle.regular),
        'folder': PhosphorIcons.folder(PhosphorIconsStyle.regular),
        'folder-dashed': PhosphorIcons.folderDashed(PhosphorIconsStyle.regular),
        'folder-lock': PhosphorIcons.folderLock(PhosphorIconsStyle.regular),
        'folder-minus': PhosphorIcons.folderMinus(PhosphorIconsStyle.regular),
        'folder-open': PhosphorIcons.folderOpen(PhosphorIconsStyle.regular),
        'folder-plus': PhosphorIcons.folderPlus(PhosphorIconsStyle.regular),
        'folders': PhosphorIcons.folders(PhosphorIconsStyle.regular),
        'folder-simple': PhosphorIcons.folderSimple(PhosphorIconsStyle.regular),
        'folder-simple-dashed':
            PhosphorIcons.folderSimpleDashed(PhosphorIconsStyle.regular),
        'folder-simple-lock':
            PhosphorIcons.folderSimpleLock(PhosphorIconsStyle.regular),
        'folder-simple-minus':
            PhosphorIcons.folderSimpleMinus(PhosphorIconsStyle.regular),
        'folder-simple-plus':
            PhosphorIcons.folderSimplePlus(PhosphorIconsStyle.regular),
        'folder-simple-star':
            PhosphorIcons.folderSimpleStar(PhosphorIconsStyle.regular),
        'folder-simple-user':
            PhosphorIcons.folderSimpleUser(PhosphorIconsStyle.regular),
        'folder-star': PhosphorIcons.folderStar(PhosphorIconsStyle.regular),
        'folder-user': PhosphorIcons.folderUser(PhosphorIconsStyle.regular),
        'football': PhosphorIcons.football(PhosphorIconsStyle.regular),
        'footprints': PhosphorIcons.footprints(PhosphorIconsStyle.regular),
        'fork-knife': PhosphorIcons.forkKnife(PhosphorIconsStyle.regular),
        'frame-corners': PhosphorIcons.frameCorners(PhosphorIconsStyle.regular),
        'framer-logo': PhosphorIcons.framerLogo(PhosphorIconsStyle.regular),
        'function': PhosphorIcons.function(PhosphorIconsStyle.regular),
        'funnel': PhosphorIcons.funnel(PhosphorIconsStyle.regular),
        'funnel-simple': PhosphorIcons.funnelSimple(PhosphorIconsStyle.regular),
        'game-controller':
            PhosphorIcons.gameController(PhosphorIconsStyle.regular),
        'garage': PhosphorIcons.garage(PhosphorIconsStyle.regular),
        'gas-can': PhosphorIcons.gasCan(PhosphorIconsStyle.regular),
        'gas-pump': PhosphorIcons.gasPump(PhosphorIconsStyle.regular),
        'gauge': PhosphorIcons.gauge(PhosphorIconsStyle.regular),
        'gavel': PhosphorIcons.gavel(PhosphorIconsStyle.regular),
        'gear': PhosphorIcons.gear(PhosphorIconsStyle.regular),
        'gear-fine': PhosphorIcons.gearFine(PhosphorIconsStyle.regular),
        'gear-six': PhosphorIcons.gearSix(PhosphorIconsStyle.regular),
        'gender-female': PhosphorIcons.genderFemale(PhosphorIconsStyle.regular),
        'gender-intersex':
            PhosphorIcons.genderIntersex(PhosphorIconsStyle.regular),
        'gender-male': PhosphorIcons.genderMale(PhosphorIconsStyle.regular),
        'gender-neuter': PhosphorIcons.genderNeuter(PhosphorIconsStyle.regular),
        'gender-nonbinary':
            PhosphorIcons.genderNonbinary(PhosphorIconsStyle.regular),
        'gender-transgender':
            PhosphorIcons.genderTransgender(PhosphorIconsStyle.regular),
        'ghost': PhosphorIcons.ghost(PhosphorIconsStyle.regular),
        'gif': PhosphorIcons.gif(PhosphorIconsStyle.regular),
        'gift': PhosphorIcons.gift(PhosphorIconsStyle.regular),
        'git-branch': PhosphorIcons.gitBranch(PhosphorIconsStyle.regular),
        'git-commit': PhosphorIcons.gitCommit(PhosphorIconsStyle.regular),
        'git-diff': PhosphorIcons.gitDiff(PhosphorIconsStyle.regular),
        'git-fork': PhosphorIcons.gitFork(PhosphorIconsStyle.regular),
        'github-logo': PhosphorIcons.githubLogo(PhosphorIconsStyle.regular),
        'gitlab-logo': PhosphorIcons.gitlabLogo(PhosphorIconsStyle.regular),
        'gitlab-logo-simple':
            PhosphorIcons.gitlabLogoSimple(PhosphorIconsStyle.regular),
        'git-merge': PhosphorIcons.gitMerge(PhosphorIconsStyle.regular),
        'git-pull-request':
            PhosphorIcons.gitPullRequest(PhosphorIconsStyle.regular),
        'globe': PhosphorIcons.globe(PhosphorIconsStyle.regular),
        'globe-hemisphere-east':
            PhosphorIcons.globeHemisphereEast(PhosphorIconsStyle.regular),
        'globe-hemisphere-west':
            PhosphorIcons.globeHemisphereWest(PhosphorIconsStyle.regular),
        'globe-simple': PhosphorIcons.globeSimple(PhosphorIconsStyle.regular),
        'globe-stand': PhosphorIcons.globeStand(PhosphorIconsStyle.regular),
        'goggles': PhosphorIcons.goggles(PhosphorIconsStyle.regular),
        'goodreads-logo':
            PhosphorIcons.goodreadsLogo(PhosphorIconsStyle.regular),
        'google-cardboard-logo':
            PhosphorIcons.googleCardboardLogo(PhosphorIconsStyle.regular),
        'google-chrome-logo':
            PhosphorIcons.googleChromeLogo(PhosphorIconsStyle.regular),
        'google-drive-logo':
            PhosphorIcons.googleDriveLogo(PhosphorIconsStyle.regular),
        'google-logo': PhosphorIcons.googleLogo(PhosphorIconsStyle.regular),
        'google-photos-logo':
            PhosphorIcons.googlePhotosLogo(PhosphorIconsStyle.regular),
        'google-play-logo':
            PhosphorIcons.googlePlayLogo(PhosphorIconsStyle.regular),
        'google-podcasts-logo':
            PhosphorIcons.googlePodcastsLogo(PhosphorIconsStyle.regular),
        'gradient': PhosphorIcons.gradient(PhosphorIconsStyle.regular),
        'graduation-cap':
            PhosphorIcons.graduationCap(PhosphorIconsStyle.regular),
        'grains': PhosphorIcons.grains(PhosphorIconsStyle.regular),
        'grains-slash': PhosphorIcons.grainsSlash(PhosphorIconsStyle.regular),
        'graph': PhosphorIcons.graph(PhosphorIconsStyle.regular),
        'grid-four': PhosphorIcons.gridFour(PhosphorIconsStyle.regular),
        'grid-nine': PhosphorIcons.gridNine(PhosphorIconsStyle.regular),
        'guitar': PhosphorIcons.guitar(PhosphorIconsStyle.regular),
        'hamburger': PhosphorIcons.hamburger(PhosphorIconsStyle.regular),
        'hammer': PhosphorIcons.hammer(PhosphorIconsStyle.regular),
        'hand': PhosphorIcons.hand(PhosphorIconsStyle.regular),
        'handbag': PhosphorIcons.handbag(PhosphorIconsStyle.regular),
        'handbag-simple':
            PhosphorIcons.handbagSimple(PhosphorIconsStyle.regular),
        'hand-coins': PhosphorIcons.handCoins(PhosphorIconsStyle.regular),
        'hand-eye': PhosphorIcons.handEye(PhosphorIconsStyle.regular),
        'hand-fist': PhosphorIcons.handFist(PhosphorIconsStyle.regular),
        'hand-grabbing': PhosphorIcons.handGrabbing(PhosphorIconsStyle.regular),
        'hand-heart': PhosphorIcons.handHeart(PhosphorIconsStyle.regular),
        'hand-palm': PhosphorIcons.handPalm(PhosphorIconsStyle.regular),
        'hand-pointing': PhosphorIcons.handPointing(PhosphorIconsStyle.regular),
        'hands-clapping':
            PhosphorIcons.handsClapping(PhosphorIconsStyle.regular),
        'handshake': PhosphorIcons.handshake(PhosphorIconsStyle.regular),
        'hand-soap': PhosphorIcons.handSoap(PhosphorIconsStyle.regular),
        'hands-praying': PhosphorIcons.handsPraying(PhosphorIconsStyle.regular),
        'hand-swipe-left':
            PhosphorIcons.handSwipeLeft(PhosphorIconsStyle.regular),
        'hand-swipe-right':
            PhosphorIcons.handSwipeRight(PhosphorIconsStyle.regular),
        'hand-tap': PhosphorIcons.handTap(PhosphorIconsStyle.regular),
        'hand-waving': PhosphorIcons.handWaving(PhosphorIconsStyle.regular),
        'hard-drive': PhosphorIcons.hardDrive(PhosphorIconsStyle.regular),
        'hard-drives': PhosphorIcons.hardDrives(PhosphorIconsStyle.regular),
        'hash': PhosphorIcons.hash(PhosphorIconsStyle.regular),
        'hash-straight': PhosphorIcons.hashStraight(PhosphorIconsStyle.regular),
        'headlights': PhosphorIcons.headlights(PhosphorIconsStyle.regular),
        'headphones': PhosphorIcons.headphones(PhosphorIconsStyle.regular),
        'headset': PhosphorIcons.headset(PhosphorIconsStyle.regular),
        'heart': PhosphorIcons.heart(PhosphorIconsStyle.regular),
        'heart-filled': PhosphorIcons.heart(PhosphorIconsStyle.fill),
        'heartbeat': PhosphorIcons.heartbeat(PhosphorIconsStyle.regular),
        'heart-break': PhosphorIcons.heartBreak(PhosphorIconsStyle.regular),
        'heart-half': PhosphorIcons.heartHalf(PhosphorIconsStyle.regular),
        'heart-straight':
            PhosphorIcons.heartStraight(PhosphorIconsStyle.regular),
        'heart-straight-break':
            PhosphorIcons.heartStraightBreak(PhosphorIconsStyle.regular),
        'hexagon': PhosphorIcons.hexagon(PhosphorIconsStyle.regular),
        'high-heel': PhosphorIcons.highHeel(PhosphorIconsStyle.regular),
        'highlighter-circle':
            PhosphorIcons.highlighterCircle(PhosphorIconsStyle.regular),
        'hoodie': PhosphorIcons.hoodie(PhosphorIconsStyle.regular),
        'horse': PhosphorIcons.horse(PhosphorIconsStyle.regular),
        'hourglass': PhosphorIcons.hourglass(PhosphorIconsStyle.regular),
        'hourglass-high':
            PhosphorIcons.hourglassHigh(PhosphorIconsStyle.regular),
        'hourglass-low': PhosphorIcons.hourglassLow(PhosphorIconsStyle.regular),
        'hourglass-medium':
            PhosphorIcons.hourglassMedium(PhosphorIconsStyle.regular),
        'hourglass-simple':
            PhosphorIcons.hourglassSimple(PhosphorIconsStyle.regular),
        'hourglass-simple-high':
            PhosphorIcons.hourglassSimpleHigh(PhosphorIconsStyle.regular),
        'hourglass-simple-low':
            PhosphorIcons.hourglassSimpleLow(PhosphorIconsStyle.regular),
        'hourglass-simple-medium':
            PhosphorIcons.hourglassSimpleMedium(PhosphorIconsStyle.regular),
        'house': PhosphorIcons.house(PhosphorIconsStyle.regular),
        'house-line': PhosphorIcons.houseLine(PhosphorIconsStyle.regular),
        'house-simple': PhosphorIcons.houseSimple(PhosphorIconsStyle.regular),
        'ice-cream': PhosphorIcons.iceCream(PhosphorIconsStyle.regular),
        'identification-badge':
            PhosphorIcons.identificationBadge(PhosphorIconsStyle.regular),
        'identification-card':
            PhosphorIcons.identificationCard(PhosphorIconsStyle.regular),
        'image': PhosphorIcons.image(PhosphorIconsStyle.regular),
        'images': PhosphorIcons.images(PhosphorIconsStyle.regular),
        'image-square': PhosphorIcons.imageSquare(PhosphorIconsStyle.regular),
        'images-square': PhosphorIcons.imagesSquare(PhosphorIconsStyle.regular),
        'infinity': PhosphorIcons.infinity(PhosphorIconsStyle.regular),
        'info': PhosphorIcons.info(PhosphorIconsStyle.regular),
        'instagram-logo':
            PhosphorIcons.instagramLogo(PhosphorIconsStyle.regular),
        'intersect': PhosphorIcons.intersect(PhosphorIconsStyle.regular),
        'intersect-square':
            PhosphorIcons.intersectSquare(PhosphorIconsStyle.regular),
        'intersect-three':
            PhosphorIcons.intersectThree(PhosphorIconsStyle.regular),
        'jeep': PhosphorIcons.jeep(PhosphorIconsStyle.regular),
        'kanban': PhosphorIcons.kanban(PhosphorIconsStyle.regular),
        'key': PhosphorIcons.key(PhosphorIconsStyle.regular),
        'keyboard': PhosphorIcons.keyboard(PhosphorIconsStyle.regular),
        'keyhole': PhosphorIcons.keyhole(PhosphorIconsStyle.regular),
        'key-return': PhosphorIcons.keyReturn(PhosphorIconsStyle.regular),
        'knife': PhosphorIcons.knife(PhosphorIconsStyle.regular),
        'ladder': PhosphorIcons.ladder(PhosphorIconsStyle.regular),
        'ladder-simple': PhosphorIcons.ladderSimple(PhosphorIconsStyle.regular),
        'lamp': PhosphorIcons.lamp(PhosphorIconsStyle.regular),
        'laptop': PhosphorIcons.laptop(PhosphorIconsStyle.regular),
        'layout': PhosphorIcons.layout(PhosphorIconsStyle.regular),
        'leaf': PhosphorIcons.leaf(PhosphorIconsStyle.regular),
        'lifebuoy': PhosphorIcons.lifebuoy(PhosphorIconsStyle.regular),
        'lightbulb': PhosphorIcons.lightbulb(PhosphorIconsStyle.regular),
        'lightbulb-filament':
            PhosphorIcons.lightbulbFilament(PhosphorIconsStyle.regular),
        'lighthouse': PhosphorIcons.lighthouse(PhosphorIconsStyle.regular),
        'lightning': PhosphorIcons.lightning(PhosphorIconsStyle.regular),
        'lightning-a': PhosphorIcons.lightningA(PhosphorIconsStyle.regular),
        'lightning-slash':
            PhosphorIcons.lightningSlash(PhosphorIconsStyle.regular),
        'line-segment': PhosphorIcons.lineSegment(PhosphorIconsStyle.regular),
        'line-segments': PhosphorIcons.lineSegments(PhosphorIconsStyle.regular),
        'link': PhosphorIcons.link(PhosphorIconsStyle.regular),
        'link-break': PhosphorIcons.linkBreak(PhosphorIconsStyle.regular),
        'linkedin-logo': PhosphorIcons.linkedinLogo(PhosphorIconsStyle.regular),
        'link-simple': PhosphorIcons.linkSimple(PhosphorIconsStyle.regular),
        'link-simple-break':
            PhosphorIcons.linkSimpleBreak(PhosphorIconsStyle.regular),
        'link-simple-horizontal':
            PhosphorIcons.linkSimpleHorizontal(PhosphorIconsStyle.regular),
        'link-simple-horizontal-break':
            PhosphorIcons.linkSimpleHorizontalBreak(PhosphorIconsStyle.regular),
        'linux-logo': PhosphorIcons.linuxLogo(PhosphorIconsStyle.regular),
        'list': PhosphorIcons.list(PhosphorIconsStyle.regular),
        'list-bullets': PhosphorIcons.listBullets(PhosphorIconsStyle.regular),
        'list-checks': PhosphorIcons.listChecks(PhosphorIconsStyle.regular),
        'list-dashes': PhosphorIcons.listDashes(PhosphorIconsStyle.regular),
        'list-magnifying-glass':
            PhosphorIcons.listMagnifyingGlass(PhosphorIconsStyle.regular),
        'list-numbers': PhosphorIcons.listNumbers(PhosphorIconsStyle.regular),
        'list-plus': PhosphorIcons.listPlus(PhosphorIconsStyle.regular),
        'lock': PhosphorIcons.lock(PhosphorIconsStyle.regular),
        'lock-fill': PhosphorIcons.lock(PhosphorIconsStyle.fill),
        'lockers': PhosphorIcons.lockers(PhosphorIconsStyle.regular),
        'lock-key': PhosphorIcons.lockKey(PhosphorIconsStyle.regular),
        'lock-key-open': PhosphorIcons.lockKeyOpen(PhosphorIconsStyle.regular),
        'lock-laminated':
            PhosphorIcons.lockLaminated(PhosphorIconsStyle.regular),
        'lock-laminated-open':
            PhosphorIcons.lockLaminatedOpen(PhosphorIconsStyle.regular),
        'lock-open': PhosphorIcons.lockOpen(PhosphorIconsStyle.regular),
        'lock-simple': PhosphorIcons.lockSimple(PhosphorIconsStyle.regular),
        'lock-simple-open':
            PhosphorIcons.lockSimpleOpen(PhosphorIconsStyle.regular),
        'magic-wand': PhosphorIcons.magicWand(PhosphorIconsStyle.regular),
        'magnet': PhosphorIcons.magnet(PhosphorIconsStyle.regular),
        'magnet-straight':
            PhosphorIcons.magnetStraight(PhosphorIconsStyle.regular),
        'magnifying-glass':
            PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.regular),
        'magnifying-glass-minus':
            PhosphorIcons.magnifyingGlassMinus(PhosphorIconsStyle.regular),
        'magnifying-glass-plus':
            PhosphorIcons.magnifyingGlassPlus(PhosphorIconsStyle.regular),
        'map-pin': PhosphorIcons.mapPin(PhosphorIconsStyle.regular),
        'map-pin-line': PhosphorIcons.mapPinLine(PhosphorIconsStyle.regular),
        'map-trifold': PhosphorIcons.mapTrifold(PhosphorIconsStyle.regular),
        'marker-circle': PhosphorIcons.markerCircle(PhosphorIconsStyle.regular),
        'martini': PhosphorIcons.martini(PhosphorIconsStyle.regular),
        'mask-happy': PhosphorIcons.maskHappy(PhosphorIconsStyle.regular),
        'mask-sad': PhosphorIcons.maskSad(PhosphorIconsStyle.regular),
        'math-operations':
            PhosphorIcons.mathOperations(PhosphorIconsStyle.regular),
        'medal': PhosphorIcons.medal(PhosphorIconsStyle.regular),
        'medal-military':
            PhosphorIcons.medalMilitary(PhosphorIconsStyle.regular),
        'medium-logo': PhosphorIcons.mediumLogo(PhosphorIconsStyle.regular),
        'megaphone': PhosphorIcons.megaphone(PhosphorIconsStyle.regular),
        'megaphone-simple':
            PhosphorIcons.megaphoneSimple(PhosphorIconsStyle.regular),
        'messenger-logo':
            PhosphorIcons.messengerLogo(PhosphorIconsStyle.regular),
        'meta-logo': PhosphorIcons.metaLogo(PhosphorIconsStyle.regular),
        'metronome': PhosphorIcons.metronome(PhosphorIconsStyle.regular),
        'microphone': PhosphorIcons.microphone(PhosphorIconsStyle.regular),
        'microphone-slash':
            PhosphorIcons.microphoneSlash(PhosphorIconsStyle.regular),
        'microphone-stage':
            PhosphorIcons.microphoneStage(PhosphorIconsStyle.regular),
        'microsoft-excel-logo':
            PhosphorIcons.microsoftExcelLogo(PhosphorIconsStyle.regular),
        'microsoft-outlook-logo':
            PhosphorIcons.microsoftOutlookLogo(PhosphorIconsStyle.regular),
        'microsoft-powerpoint-logo':
            PhosphorIcons.microsoftPowerpointLogo(PhosphorIconsStyle.regular),
        'microsoft-teams-logo':
            PhosphorIcons.microsoftTeamsLogo(PhosphorIconsStyle.regular),
        'microsoft-word-logo':
            PhosphorIcons.microsoftWordLogo(PhosphorIconsStyle.regular),
        'minus': PhosphorIcons.minus(PhosphorIconsStyle.regular),
        'minus-circle': PhosphorIcons.minusCircle(PhosphorIconsStyle.regular),
        'minus-square': PhosphorIcons.minusSquare(PhosphorIconsStyle.regular),
        'money': PhosphorIcons.money(PhosphorIconsStyle.regular),
        'monitor': PhosphorIcons.monitor(PhosphorIconsStyle.regular),
        'monitor-play': PhosphorIcons.monitorPlay(PhosphorIconsStyle.regular),
        'moon': PhosphorIcons.moon(PhosphorIconsStyle.regular),
        'moon-stars': PhosphorIcons.moonStars(PhosphorIconsStyle.regular),
        'moped': PhosphorIcons.moped(PhosphorIconsStyle.regular),
        'moped-front': PhosphorIcons.mopedFront(PhosphorIconsStyle.regular),
        'mosque': PhosphorIcons.mosque(PhosphorIconsStyle.regular),
        'motorcycle': PhosphorIcons.motorcycle(PhosphorIconsStyle.regular),
        'mountains': PhosphorIcons.mountains(PhosphorIconsStyle.regular),
        'mouse': PhosphorIcons.mouse(PhosphorIconsStyle.regular),
        'mouse-simple': PhosphorIcons.mouseSimple(PhosphorIconsStyle.regular),
        'music-note': PhosphorIcons.musicNote(PhosphorIconsStyle.regular),
        'music-notes': PhosphorIcons.musicNotes(PhosphorIconsStyle.regular),
        'music-note-simple':
            PhosphorIcons.musicNoteSimple(PhosphorIconsStyle.regular),
        'music-notes-plus':
            PhosphorIcons.musicNotesPlus(PhosphorIconsStyle.regular),
        'music-notes-simple':
            PhosphorIcons.musicNotesSimple(PhosphorIconsStyle.regular),
        'navigation-arrow':
            PhosphorIcons.navigationArrow(PhosphorIconsStyle.regular),
        'needle': PhosphorIcons.needle(PhosphorIconsStyle.regular),
        'newspaper': PhosphorIcons.newspaper(PhosphorIconsStyle.regular),
        'newspaper-clipping':
            PhosphorIcons.newspaperClipping(PhosphorIconsStyle.regular),
        'notches': PhosphorIcons.notches(PhosphorIconsStyle.regular),
        'note': PhosphorIcons.note(PhosphorIconsStyle.regular),
        'note-blank': PhosphorIcons.noteBlank(PhosphorIconsStyle.regular),
        'notebook': PhosphorIcons.notebook(PhosphorIconsStyle.regular),
        'notepad': PhosphorIcons.notepad(PhosphorIconsStyle.regular),
        'note-pencil': PhosphorIcons.notePencil(PhosphorIconsStyle.regular),
        'notification': PhosphorIcons.notification(PhosphorIconsStyle.regular),
        'notion-logo': PhosphorIcons.notionLogo(PhosphorIconsStyle.regular),
        'number-circle-eight':
            PhosphorIcons.numberCircleEight(PhosphorIconsStyle.regular),
        'number-circle-five':
            PhosphorIcons.numberCircleFive(PhosphorIconsStyle.regular),
        'number-circle-four':
            PhosphorIcons.numberCircleFour(PhosphorIconsStyle.regular),
        'number-circle-nine':
            PhosphorIcons.numberCircleNine(PhosphorIconsStyle.regular),
        'number-circle-one':
            PhosphorIcons.numberCircleOne(PhosphorIconsStyle.regular),
        'number-circle-seven':
            PhosphorIcons.numberCircleSeven(PhosphorIconsStyle.regular),
        'number-circle-six':
            PhosphorIcons.numberCircleSix(PhosphorIconsStyle.regular),
        'number-circle-three':
            PhosphorIcons.numberCircleThree(PhosphorIconsStyle.regular),
        'number-circle-two':
            PhosphorIcons.numberCircleTwo(PhosphorIconsStyle.regular),
        'number-circle-zero':
            PhosphorIcons.numberCircleZero(PhosphorIconsStyle.regular),
        'number-eight': PhosphorIcons.numberEight(PhosphorIconsStyle.regular),
        'number-five': PhosphorIcons.numberFive(PhosphorIconsStyle.regular),
        'number-four': PhosphorIcons.numberFour(PhosphorIconsStyle.regular),
        'number-nine': PhosphorIcons.numberNine(PhosphorIconsStyle.regular),
        'number-one': PhosphorIcons.numberOne(PhosphorIconsStyle.regular),
        'number-seven': PhosphorIcons.numberSeven(PhosphorIconsStyle.regular),
        'number-six': PhosphorIcons.numberSix(PhosphorIconsStyle.regular),
        'number-square-eight':
            PhosphorIcons.numberSquareEight(PhosphorIconsStyle.regular),
        'number-square-five':
            PhosphorIcons.numberSquareFive(PhosphorIconsStyle.regular),
        'number-square-four':
            PhosphorIcons.numberSquareFour(PhosphorIconsStyle.regular),
        'number-square-nine':
            PhosphorIcons.numberSquareNine(PhosphorIconsStyle.regular),
        'number-square-one':
            PhosphorIcons.numberSquareOne(PhosphorIconsStyle.regular),
        'number-square-seven':
            PhosphorIcons.numberSquareSeven(PhosphorIconsStyle.regular),
        'number-square-six':
            PhosphorIcons.numberSquareSix(PhosphorIconsStyle.regular),
        'number-square-three':
            PhosphorIcons.numberSquareThree(PhosphorIconsStyle.regular),
        'number-square-two':
            PhosphorIcons.numberSquareTwo(PhosphorIconsStyle.regular),
        'number-square-zero':
            PhosphorIcons.numberSquareZero(PhosphorIconsStyle.regular),
        'number-three': PhosphorIcons.numberThree(PhosphorIconsStyle.regular),
        'number-two': PhosphorIcons.numberTwo(PhosphorIconsStyle.regular),
        'number-zero': PhosphorIcons.numberZero(PhosphorIconsStyle.regular),
        'nut': PhosphorIcons.nut(PhosphorIconsStyle.regular),
        'ny-times-logo': PhosphorIcons.nyTimesLogo(PhosphorIconsStyle.regular),
        'octagon': PhosphorIcons.octagon(PhosphorIconsStyle.regular),
        'office-chair': PhosphorIcons.officeChair(PhosphorIconsStyle.regular),
        'option': PhosphorIcons.option(PhosphorIconsStyle.regular),
        'orange-slice': PhosphorIcons.orangeSlice(PhosphorIconsStyle.regular),
        'package': PhosphorIcons.package(PhosphorIconsStyle.regular),
        'paint-brush': PhosphorIcons.paintBrush(PhosphorIconsStyle.regular),
        'paint-brush-broad':
            PhosphorIcons.paintBrushBroad(PhosphorIconsStyle.regular),
        'paint-brush-household':
            PhosphorIcons.paintBrushHousehold(PhosphorIconsStyle.regular),
        'paint-bucket': PhosphorIcons.paintBucket(PhosphorIconsStyle.regular),
        'paint-roller': PhosphorIcons.paintRoller(PhosphorIconsStyle.regular),
        'palette': PhosphorIcons.palette(PhosphorIconsStyle.regular),
        'pants': PhosphorIcons.pants(PhosphorIconsStyle.regular),
        'paperclip': PhosphorIcons.paperclip(PhosphorIconsStyle.regular),
        'paperclip-horizontal':
            PhosphorIcons.paperclipHorizontal(PhosphorIconsStyle.regular),
        'paper-plane': PhosphorIcons.paperPlane(PhosphorIconsStyle.regular),
        'paper-plane-right':
            PhosphorIcons.paperPlaneRight(PhosphorIconsStyle.regular),
        'paper-plane-tilt':
            PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.regular),
        'parachute': PhosphorIcons.parachute(PhosphorIconsStyle.regular),
        'paragraph': PhosphorIcons.paragraph(PhosphorIconsStyle.regular),
        'parallelogram':
            PhosphorIcons.parallelogram(PhosphorIconsStyle.regular),
        'park': PhosphorIcons.park(PhosphorIconsStyle.regular),
        'password': PhosphorIcons.password(PhosphorIconsStyle.regular),
        'path': PhosphorIcons.path(PhosphorIconsStyle.regular),
        'patreon-logo': PhosphorIcons.patreonLogo(PhosphorIconsStyle.regular),
        'pause': PhosphorIcons.pause(PhosphorIconsStyle.regular),
        'pause-circle': PhosphorIcons.pauseCircle(PhosphorIconsStyle.regular),
        'paw-print': PhosphorIcons.pawPrint(PhosphorIconsStyle.regular),
        'paypal-logo': PhosphorIcons.paypalLogo(PhosphorIconsStyle.regular),
        'peace': PhosphorIcons.peace(PhosphorIconsStyle.regular),
        'pen': PhosphorIcons.pen(PhosphorIconsStyle.regular),
        'pencil': PhosphorIcons.pencil(PhosphorIconsStyle.regular),
        'pencil-circle': PhosphorIcons.pencilCircle(PhosphorIconsStyle.regular),
        'pencil-line': PhosphorIcons.pencilLine(PhosphorIconsStyle.regular),
        'pencil-simple': PhosphorIcons.pencilSimple(PhosphorIconsStyle.regular),
        'pencil-simple-line':
            PhosphorIcons.pencilSimpleLine(PhosphorIconsStyle.regular),
        'pencil-simple-slash':
            PhosphorIcons.pencilSimpleSlash(PhosphorIconsStyle.regular),
        'pencil-slash': PhosphorIcons.pencilSlash(PhosphorIconsStyle.regular),
        'pen-nib': PhosphorIcons.penNib(PhosphorIconsStyle.regular),
        'pen-nib-straight':
            PhosphorIcons.penNibStraight(PhosphorIconsStyle.regular),
        'pentagram': PhosphorIcons.pentagram(PhosphorIconsStyle.regular),
        'pepper': PhosphorIcons.pepper(PhosphorIconsStyle.regular),
        'percent': PhosphorIcons.percent(PhosphorIconsStyle.regular),
        'person': PhosphorIcons.person(PhosphorIconsStyle.regular),
        'person-arms-spread':
            PhosphorIcons.personArmsSpread(PhosphorIconsStyle.regular),
        'person-simple': PhosphorIcons.personSimple(PhosphorIconsStyle.regular),
        'person-simple-bike':
            PhosphorIcons.personSimpleBike(PhosphorIconsStyle.regular),
        'person-simple-run':
            PhosphorIcons.personSimpleRun(PhosphorIconsStyle.regular),
        'person-simple-throw':
            PhosphorIcons.personSimpleThrow(PhosphorIconsStyle.regular),
        'person-simple-walk':
            PhosphorIcons.personSimpleWalk(PhosphorIconsStyle.regular),
        'perspective': PhosphorIcons.perspective(PhosphorIconsStyle.regular),
        'phone': PhosphorIcons.phone(PhosphorIconsStyle.regular),
        'phone-call': PhosphorIcons.phoneCall(PhosphorIconsStyle.regular),
        'phone-disconnect':
            PhosphorIcons.phoneDisconnect(PhosphorIconsStyle.regular),
        'phone-incoming':
            PhosphorIcons.phoneIncoming(PhosphorIconsStyle.regular),
        'phone-outgoing':
            PhosphorIcons.phoneOutgoing(PhosphorIconsStyle.regular),
        'phone-plus': PhosphorIcons.phonePlus(PhosphorIconsStyle.regular),
        'phone-slash': PhosphorIcons.phoneSlash(PhosphorIconsStyle.regular),
        'phone-x': PhosphorIcons.phoneX(PhosphorIconsStyle.regular),
        'phosphor-logo': PhosphorIcons.phosphorLogo(PhosphorIconsStyle.regular),
        'pi': PhosphorIcons.pi(PhosphorIconsStyle.regular),
        'piano-keys': PhosphorIcons.pianoKeys(PhosphorIconsStyle.regular),
        'picture-in-picture':
            PhosphorIcons.pictureInpicture(PhosphorIconsStyle.regular),
        'piggy-bank': PhosphorIcons.piggyBank(PhosphorIconsStyle.regular),
        'pill': PhosphorIcons.pill(PhosphorIconsStyle.regular),
        'pinterest-logo':
            PhosphorIcons.pinterestLogo(PhosphorIconsStyle.regular),
        'pinwheel': PhosphorIcons.pinwheel(PhosphorIconsStyle.regular),
        'pizza': PhosphorIcons.pizza(PhosphorIconsStyle.regular),
        'placeholder': PhosphorIcons.placeholder(PhosphorIconsStyle.regular),
        'planet': PhosphorIcons.planet(PhosphorIconsStyle.regular),
        'plant': PhosphorIcons.plant(PhosphorIconsStyle.regular),
        'play': PhosphorIcons.play(PhosphorIconsStyle.regular),
        'play-fill': PhosphorIcons.playCircle(PhosphorIconsStyle.fill),
        'play-circle': PhosphorIcons.playCircle(PhosphorIconsStyle.regular),
        'playlist': PhosphorIcons.playlist(PhosphorIconsStyle.regular),
        'play-pause': PhosphorIcons.playPause(PhosphorIconsStyle.regular),
        'plug': PhosphorIcons.plug(PhosphorIconsStyle.regular),
        'plug-charging': PhosphorIcons.plugCharging(PhosphorIconsStyle.regular),
        'plugs': PhosphorIcons.plugs(PhosphorIconsStyle.regular),
        'plugs-connected':
            PhosphorIcons.plugsConnected(PhosphorIconsStyle.regular),
        'plus': PhosphorIcons.plus(PhosphorIconsStyle.regular),
        'plus-circle': PhosphorIcons.plusCircle(PhosphorIconsStyle.regular),
        'plus-minus': PhosphorIcons.plusMinus(PhosphorIconsStyle.regular),
        'plus-square': PhosphorIcons.plusSquare(PhosphorIconsStyle.regular),
        'poker-chip': PhosphorIcons.pokerChip(PhosphorIconsStyle.regular),
        'police-car': PhosphorIcons.policeCar(PhosphorIconsStyle.regular),
        'polygon': PhosphorIcons.polygon(PhosphorIconsStyle.regular),
        'popcorn': PhosphorIcons.popcorn(PhosphorIconsStyle.regular),
        'potted-plant': PhosphorIcons.pottedPlant(PhosphorIconsStyle.regular),
        'power': PhosphorIcons.power(PhosphorIconsStyle.regular),
        'prescription': PhosphorIcons.prescription(PhosphorIconsStyle.regular),
        'presentation': PhosphorIcons.presentation(PhosphorIconsStyle.regular),
        'presentation-chart':
            PhosphorIcons.presentationChart(PhosphorIconsStyle.regular),
        'printer': PhosphorIcons.printer(PhosphorIconsStyle.regular),
        'prohibit': PhosphorIcons.prohibit(PhosphorIconsStyle.regular),
        'prohibit-inset':
            PhosphorIcons.prohibitInset(PhosphorIconsStyle.regular),
        'projector-screen':
            PhosphorIcons.projectorScreen(PhosphorIconsStyle.regular),
        'projector-screen-chart':
            PhosphorIcons.projectorScreenChart(PhosphorIconsStyle.regular),
        'pulse': PhosphorIcons.pulse(PhosphorIconsStyle.regular),
        'push-pin': PhosphorIcons.pushPin(PhosphorIconsStyle.regular),
        'push-pin-simple':
            PhosphorIcons.pushPinSimple(PhosphorIconsStyle.regular),
        'push-pin-simple-slash':
            PhosphorIcons.pushPinSimpleSlash(PhosphorIconsStyle.regular),
        'push-pin-slash':
            PhosphorIcons.pushPinSlash(PhosphorIconsStyle.regular),
        'puzzle-piece': PhosphorIcons.puzzlePiece(PhosphorIconsStyle.regular),
        'qr-code': PhosphorIcons.qrCode(PhosphorIconsStyle.regular),
        'question': PhosphorIcons.question(PhosphorIconsStyle.regular),
        'queue': PhosphorIcons.queue(PhosphorIconsStyle.regular),
        'quotes': PhosphorIcons.quotes(PhosphorIconsStyle.regular),
        'radical': PhosphorIcons.radical(PhosphorIconsStyle.regular),
        'radio': PhosphorIcons.radio(PhosphorIconsStyle.regular),
        'radioactive': PhosphorIcons.radioactive(PhosphorIconsStyle.regular),
        'radio-button': PhosphorIcons.radioButton(PhosphorIconsStyle.regular),
        'rainbow': PhosphorIcons.rainbow(PhosphorIconsStyle.regular),
        'rainbow-cloud': PhosphorIcons.rainbowCloud(PhosphorIconsStyle.regular),
        'read-cv-logo': PhosphorIcons.readCvLogo(PhosphorIconsStyle.regular),
        'receipt': PhosphorIcons.receipt(PhosphorIconsStyle.regular),
        'receipt-x': PhosphorIcons.receiptX(PhosphorIconsStyle.regular),
        'record': PhosphorIcons.record(PhosphorIconsStyle.regular),
        'rectangle': PhosphorIcons.rectangle(PhosphorIconsStyle.regular),
        'recycle': PhosphorIcons.recycle(PhosphorIconsStyle.regular),
        'reddit-logo': PhosphorIcons.redditLogo(PhosphorIconsStyle.regular),
        'repeat': PhosphorIcons.repeat(PhosphorIconsStyle.regular),
        'repeat-once': PhosphorIcons.repeatOnce(PhosphorIconsStyle.regular),
        'rewind': PhosphorIcons.rewind(PhosphorIconsStyle.regular),
        'rewind-circle': PhosphorIcons.rewindCircle(PhosphorIconsStyle.regular),
        'road-horizon': PhosphorIcons.roadHorizon(PhosphorIconsStyle.regular),
        'robot': PhosphorIcons.robot(PhosphorIconsStyle.regular),
        'rocket': PhosphorIcons.rocket(PhosphorIconsStyle.regular),
        'rocket-launch': PhosphorIcons.rocketLaunch(PhosphorIconsStyle.regular),
        'rows': PhosphorIcons.rows(PhosphorIconsStyle.regular),
        'rss': PhosphorIcons.rss(PhosphorIconsStyle.regular),
        'rss-simple': PhosphorIcons.rssSimple(PhosphorIconsStyle.regular),
        'rug': PhosphorIcons.rug(PhosphorIconsStyle.regular),
        'ruler': PhosphorIcons.ruler(PhosphorIconsStyle.regular),
        'scales': PhosphorIcons.scales(PhosphorIconsStyle.regular),
        'scan': PhosphorIcons.scan(PhosphorIconsStyle.regular),
        'scissors': PhosphorIcons.scissors(PhosphorIconsStyle.regular),
        'scooter': PhosphorIcons.scooter(PhosphorIconsStyle.regular),
        'screencast': PhosphorIcons.screencast(PhosphorIconsStyle.regular),
        'scribble-loop': PhosphorIcons.scribbleLoop(PhosphorIconsStyle.regular),
        'scroll': PhosphorIcons.scroll(PhosphorIconsStyle.regular),
        'seal': PhosphorIcons.seal(PhosphorIconsStyle.regular),
        'seal-check': PhosphorIcons.sealCheck(PhosphorIconsStyle.regular),
        'seal-question': PhosphorIcons.sealQuestion(PhosphorIconsStyle.regular),
        'seal-warning': PhosphorIcons.sealWarning(PhosphorIconsStyle.regular),
        'selection': PhosphorIcons.selection(PhosphorIconsStyle.regular),
        'selection-all': PhosphorIcons.selectionAll(PhosphorIconsStyle.regular),
        'selection-background':
            PhosphorIcons.selectionBackground(PhosphorIconsStyle.regular),
        'selection-foreground':
            PhosphorIcons.selectionForeground(PhosphorIconsStyle.regular),
        'selection-inverse':
            PhosphorIcons.selectionInverse(PhosphorIconsStyle.regular),
        'selection-plus':
            PhosphorIcons.selectionPlus(PhosphorIconsStyle.regular),
        'selection-slash':
            PhosphorIcons.selectionSlash(PhosphorIconsStyle.regular),
        'shapes': PhosphorIcons.shapes(PhosphorIconsStyle.regular),
        'share': PhosphorIcons.share(PhosphorIconsStyle.regular),
        'share-fat': PhosphorIcons.shareFat(PhosphorIconsStyle.regular),
        'share-network': PhosphorIcons.shareNetwork(PhosphorIconsStyle.regular),
        'shield': PhosphorIcons.shield(PhosphorIconsStyle.regular),
        'shield-check': PhosphorIcons.shieldCheck(PhosphorIconsStyle.regular),
        'shield-checkered':
            PhosphorIcons.shieldCheckered(PhosphorIconsStyle.regular),
        'shield-chevron':
            PhosphorIcons.shieldChevron(PhosphorIconsStyle.regular),
        'shield-plus': PhosphorIcons.shieldPlus(PhosphorIconsStyle.regular),
        'shield-slash': PhosphorIcons.shieldSlash(PhosphorIconsStyle.regular),
        'shield-star': PhosphorIcons.shieldStar(PhosphorIconsStyle.regular),
        'shield-warning':
            PhosphorIcons.shieldWarning(PhosphorIconsStyle.regular),
        'shirt-folded': PhosphorIcons.shirtFolded(PhosphorIconsStyle.regular),
        'shooting-star': PhosphorIcons.shootingStar(PhosphorIconsStyle.regular),
        'shopping-bag': PhosphorIcons.shoppingBag(PhosphorIconsStyle.regular),
        'shopping-bag-open':
            PhosphorIcons.shoppingBagOpen(PhosphorIconsStyle.regular),
        'shopping-cart': PhosphorIcons.shoppingCart(PhosphorIconsStyle.regular),
        'shopping-cart-simple':
            PhosphorIcons.shoppingCartSimple(PhosphorIconsStyle.regular),
        'shower': PhosphorIcons.shower(PhosphorIconsStyle.regular),
        'shrimp': PhosphorIcons.shrimp(PhosphorIconsStyle.regular),
        'shuffle': PhosphorIcons.shuffle(PhosphorIconsStyle.regular),
        'shuffle-angular':
            PhosphorIcons.shuffleAngular(PhosphorIconsStyle.regular),
        'shuffle-simple':
            PhosphorIcons.shuffleSimple(PhosphorIconsStyle.regular),
        'sidebar': PhosphorIcons.sidebar(PhosphorIconsStyle.regular),
        'sidebar-simple':
            PhosphorIcons.sidebarSimple(PhosphorIconsStyle.regular),
        'sigma': PhosphorIcons.sigma(PhosphorIconsStyle.regular),
        'signature': PhosphorIcons.signature(PhosphorIconsStyle.regular),
        'sign-in': PhosphorIcons.signIn(PhosphorIconsStyle.regular),
        'sign-out': PhosphorIcons.signOut(PhosphorIconsStyle.regular),
        'signpost': PhosphorIcons.signpost(PhosphorIconsStyle.regular),
        'sim-card': PhosphorIcons.simCard(PhosphorIconsStyle.regular),
        'siren': PhosphorIcons.siren(PhosphorIconsStyle.regular),
        'sketch-logo': PhosphorIcons.sketchLogo(PhosphorIconsStyle.regular),
        'skip-back': PhosphorIcons.skipBack(PhosphorIconsStyle.regular),
        'skip-back-circle':
            PhosphorIcons.skipBackCircle(PhosphorIconsStyle.regular),
        'skip-forward': PhosphorIcons.skipForward(PhosphorIconsStyle.regular),
        'skip-forward-circle':
            PhosphorIcons.skipForwardCircle(PhosphorIconsStyle.regular),
        'skull': PhosphorIcons.skull(PhosphorIconsStyle.regular),
        'slack-logo': PhosphorIcons.slackLogo(PhosphorIconsStyle.regular),
        'sliders': PhosphorIcons.sliders(PhosphorIconsStyle.regular),
        'sliders-horizontal':
            PhosphorIcons.slidersHorizontal(PhosphorIconsStyle.regular),
        'slideshow': PhosphorIcons.slideshow(PhosphorIconsStyle.regular),
        'smiley': PhosphorIcons.smiley(PhosphorIconsStyle.regular),
        'smiley-angry': PhosphorIcons.smileyAngry(PhosphorIconsStyle.regular),
        'smiley-blank': PhosphorIcons.smileyBlank(PhosphorIconsStyle.regular),
        'smiley-meh': PhosphorIcons.smileyMeh(PhosphorIconsStyle.regular),
        'smiley-nervous':
            PhosphorIcons.smileyNervous(PhosphorIconsStyle.regular),
        'smiley-sad': PhosphorIcons.smileySad(PhosphorIconsStyle.regular),
        'smiley-sticker':
            PhosphorIcons.smileySticker(PhosphorIconsStyle.regular),
        'smiley-wink': PhosphorIcons.smileyWink(PhosphorIconsStyle.regular),
        'smiley-x-eyes': PhosphorIcons.smileyXEyes(PhosphorIconsStyle.regular),
        'snapchat-logo': PhosphorIcons.snapchatLogo(PhosphorIconsStyle.regular),
        'sneaker': PhosphorIcons.sneaker(PhosphorIconsStyle.regular),
        'sneaker-move': PhosphorIcons.sneakerMove(PhosphorIconsStyle.regular),
        'snowflake': PhosphorIcons.snowflake(PhosphorIconsStyle.regular),
        'soccer-ball': PhosphorIcons.soccerBall(PhosphorIconsStyle.regular),
        'sort-ascending':
            PhosphorIcons.sortAscending(PhosphorIconsStyle.regular),
        'sort-descending':
            PhosphorIcons.sortDescending(PhosphorIconsStyle.regular),
        'soundcloud-logo':
            PhosphorIcons.soundcloudLogo(PhosphorIconsStyle.regular),
        'spade': PhosphorIcons.spade(PhosphorIconsStyle.regular),
        'sparkle': PhosphorIcons.sparkle(PhosphorIconsStyle.regular),
        'speaker-hifi': PhosphorIcons.speakerHifi(PhosphorIconsStyle.regular),
        'speaker-high': PhosphorIcons.speakerHigh(PhosphorIconsStyle.regular),
        'speaker-low': PhosphorIcons.speakerLow(PhosphorIconsStyle.regular),
        'speaker-none': PhosphorIcons.speakerNone(PhosphorIconsStyle.regular),
        'speaker-simple-high':
            PhosphorIcons.speakerSimpleHigh(PhosphorIconsStyle.regular),
        'speaker-simple-low':
            PhosphorIcons.speakerSimpleLow(PhosphorIconsStyle.regular),
        'speaker-simple-none':
            PhosphorIcons.speakerSimpleNone(PhosphorIconsStyle.regular),
        'speaker-simple-slash':
            PhosphorIcons.speakerSimpleSlash(PhosphorIconsStyle.regular),
        'speaker-simple-x':
            PhosphorIcons.speakerSimpleX(PhosphorIconsStyle.regular),
        'speaker-slash': PhosphorIcons.speakerSlash(PhosphorIconsStyle.regular),
        'speaker-x': PhosphorIcons.speakerX(PhosphorIconsStyle.regular),
        'spinner': PhosphorIcons.spinner(PhosphorIconsStyle.regular),
        'spinner-gap': PhosphorIcons.spinnerGap(PhosphorIconsStyle.regular),
        'spiral': PhosphorIcons.spiral(PhosphorIconsStyle.regular),
        'split-horizontal':
            PhosphorIcons.splitHorizontal(PhosphorIconsStyle.regular),
        'split-vertical':
            PhosphorIcons.splitVertical(PhosphorIconsStyle.regular),
        'spotify-logo': PhosphorIcons.spotifyLogo(PhosphorIconsStyle.regular),
        'square': PhosphorIcons.square(PhosphorIconsStyle.regular),
        'square-half': PhosphorIcons.squareHalf(PhosphorIconsStyle.regular),
        'square-half-bottom':
            PhosphorIcons.squareHalfBottom(PhosphorIconsStyle.regular),
        'square-logo': PhosphorIcons.squareLogo(PhosphorIconsStyle.regular),
        'squares-four': PhosphorIcons.squaresFour(PhosphorIconsStyle.regular),
        'square-split-horizontal':
            PhosphorIcons.squareSplitHorizontal(PhosphorIconsStyle.regular),
        'square-split-vertical':
            PhosphorIcons.squareSplitVertical(PhosphorIconsStyle.regular),
        'stack': PhosphorIcons.stack(PhosphorIconsStyle.regular),
        'stack-overflow-logo':
            PhosphorIcons.stackOverflowLogo(PhosphorIconsStyle.regular),
        'stack-simple': PhosphorIcons.stackSimple(PhosphorIconsStyle.regular),
        'stairs': PhosphorIcons.stairs(PhosphorIconsStyle.regular),
        'stamp': PhosphorIcons.stamp(PhosphorIconsStyle.regular),
        'star': PhosphorIcons.star(PhosphorIconsStyle.regular),
        'star-and-crescent':
            PhosphorIcons.starAndCrescent(PhosphorIconsStyle.regular),
        'star-four': PhosphorIcons.starFour(PhosphorIconsStyle.regular),
        'star-half': PhosphorIcons.starHalf(PhosphorIconsStyle.regular),
        'star-of-david': PhosphorIcons.starOfDavid(PhosphorIconsStyle.regular),
        'steering-wheel':
            PhosphorIcons.steeringWheel(PhosphorIconsStyle.regular),
        'steps': PhosphorIcons.steps(PhosphorIconsStyle.regular),
        'stethoscope': PhosphorIcons.stethoscope(PhosphorIconsStyle.regular),
        'sticker': PhosphorIcons.sticker(PhosphorIconsStyle.regular),
        'stool': PhosphorIcons.stool(PhosphorIconsStyle.regular),
        'stop': PhosphorIcons.stop(PhosphorIconsStyle.regular),
        'stop-circle': PhosphorIcons.stopCircle(PhosphorIconsStyle.regular),
        'storefront': PhosphorIcons.storefront(PhosphorIconsStyle.regular),
        'strategy': PhosphorIcons.strategy(PhosphorIconsStyle.regular),
        'stripe-logo': PhosphorIcons.stripeLogo(PhosphorIconsStyle.regular),
        'student': PhosphorIcons.student(PhosphorIconsStyle.regular),
        'subtitles': PhosphorIcons.subtitles(PhosphorIconsStyle.regular),
        'subtract': PhosphorIcons.subtract(PhosphorIconsStyle.regular),
        'subtract-square':
            PhosphorIcons.subtractSquare(PhosphorIconsStyle.regular),
        'suitcase': PhosphorIcons.suitcase(PhosphorIconsStyle.regular),
        'suitcase-rolling':
            PhosphorIcons.suitcaseRolling(PhosphorIconsStyle.regular),
        'suitcase-simple':
            PhosphorIcons.suitcaseSimple(PhosphorIconsStyle.regular),
        'sun': PhosphorIcons.sun(PhosphorIconsStyle.regular),
        'sun-dim': PhosphorIcons.sunDim(PhosphorIconsStyle.regular),
        'sunglasses': PhosphorIcons.sunglasses(PhosphorIconsStyle.regular),
        'sun-horizon': PhosphorIcons.sunHorizon(PhosphorIconsStyle.regular),
        'swap': PhosphorIcons.swap(PhosphorIconsStyle.regular),
        'swatches': PhosphorIcons.swatches(PhosphorIconsStyle.regular),
        'swimming-pool': PhosphorIcons.swimmingPool(PhosphorIconsStyle.regular),
        'sword': PhosphorIcons.sword(PhosphorIconsStyle.regular),
        'synagogue': PhosphorIcons.synagogue(PhosphorIconsStyle.regular),
        'syringe': PhosphorIcons.syringe(PhosphorIconsStyle.regular),
        'table': PhosphorIcons.table(PhosphorIconsStyle.regular),
        'tabs': PhosphorIcons.tabs(PhosphorIconsStyle.regular),
        'tag': PhosphorIcons.tag(PhosphorIconsStyle.regular),
        'tag-chevron': PhosphorIcons.tagChevron(PhosphorIconsStyle.regular),
        'tag-simple': PhosphorIcons.tagSimple(PhosphorIconsStyle.regular),
        'target': PhosphorIcons.target(PhosphorIconsStyle.regular),
        'taxi': PhosphorIcons.taxi(PhosphorIconsStyle.regular),
        'telegram-logo': PhosphorIcons.telegramLogo(PhosphorIconsStyle.regular),
        'television': PhosphorIcons.television(PhosphorIconsStyle.regular),
        'television-simple':
            PhosphorIcons.televisionSimple(PhosphorIconsStyle.regular),
        'tennis-ball': PhosphorIcons.tennisBall(PhosphorIconsStyle.regular),
        'tent': PhosphorIcons.tent(PhosphorIconsStyle.regular),
        'terminal': PhosphorIcons.terminal(PhosphorIconsStyle.regular),
        'terminal-window':
            PhosphorIcons.terminalWindow(PhosphorIconsStyle.regular),
        'test-tube': PhosphorIcons.testTube(PhosphorIconsStyle.regular),
        'text-aa': PhosphorIcons.textAa(PhosphorIconsStyle.regular),
        'text-align-center':
            PhosphorIcons.textAlignCenter(PhosphorIconsStyle.regular),
        'text-align-justify':
            PhosphorIcons.textAlignJustify(PhosphorIconsStyle.regular),
        'text-align-left':
            PhosphorIcons.textAlignLeft(PhosphorIconsStyle.regular),
        'text-align-right':
            PhosphorIcons.textAlignRight(PhosphorIconsStyle.regular),
        'text-a-underline':
            PhosphorIcons.textAUnderline(PhosphorIconsStyle.regular),
        'text-b': PhosphorIcons.textB(PhosphorIconsStyle.regular),
        'textbox': PhosphorIcons.textbox(PhosphorIconsStyle.regular),
        'text-columns': PhosphorIcons.textColumns(PhosphorIconsStyle.regular),
        'text-h': PhosphorIcons.textH(PhosphorIconsStyle.regular),
        'text-h-five': PhosphorIcons.textHFive(PhosphorIconsStyle.regular),
        'text-h-four': PhosphorIcons.textHFour(PhosphorIconsStyle.regular),
        'text-h-one': PhosphorIcons.textHOne(PhosphorIconsStyle.regular),
        'text-h-six': PhosphorIcons.textHSix(PhosphorIconsStyle.regular),
        'text-h-three': PhosphorIcons.textHThree(PhosphorIconsStyle.regular),
        'text-h-two': PhosphorIcons.textHTwo(PhosphorIconsStyle.regular),
        'text-indent': PhosphorIcons.textIndent(PhosphorIconsStyle.regular),
        'text-italic': PhosphorIcons.textItalic(PhosphorIconsStyle.regular),
        'text-outdent': PhosphorIcons.textOutdent(PhosphorIconsStyle.regular),
        'text-strikethrough':
            PhosphorIcons.textStrikethrough(PhosphorIconsStyle.regular),
        'text-t': PhosphorIcons.textT(PhosphorIconsStyle.regular),
        'text-underline':
            PhosphorIcons.textUnderline(PhosphorIconsStyle.regular),
        'thermometer': PhosphorIcons.thermometer(PhosphorIconsStyle.regular),
        'thermometer-cold':
            PhosphorIcons.thermometerCold(PhosphorIconsStyle.regular),
        'thermometer-hot':
            PhosphorIcons.thermometerHot(PhosphorIconsStyle.regular),
        'thermometer-simple':
            PhosphorIcons.thermometerSimple(PhosphorIconsStyle.regular),
        'thumbs-down': PhosphorIcons.thumbsDown(PhosphorIconsStyle.regular),
        'thumbs-up': PhosphorIcons.thumbsUp(PhosphorIconsStyle.regular),
        'ticket': PhosphorIcons.ticket(PhosphorIconsStyle.regular),
        'tidal-logo': PhosphorIcons.tidalLogo(PhosphorIconsStyle.regular),
        'tiktok-logo': PhosphorIcons.tiktokLogo(PhosphorIconsStyle.regular),
        'timer': PhosphorIcons.timer(PhosphorIconsStyle.regular),
        'tipi': PhosphorIcons.tipi(PhosphorIconsStyle.regular),
        'toggle-left': PhosphorIcons.toggleLeft(PhosphorIconsStyle.regular),
        'toggle-right': PhosphorIcons.toggleRight(PhosphorIconsStyle.regular),
        'toilet': PhosphorIcons.toilet(PhosphorIconsStyle.regular),
        'toilet-paper': PhosphorIcons.toiletPaper(PhosphorIconsStyle.regular),
        'toolbox': PhosphorIcons.toolbox(PhosphorIconsStyle.regular),
        'tooth': PhosphorIcons.tooth(PhosphorIconsStyle.regular),
        'tote': PhosphorIcons.tote(PhosphorIconsStyle.regular),
        'tote-simple': PhosphorIcons.toteSimple(PhosphorIconsStyle.regular),
        'trademark': PhosphorIcons.trademark(PhosphorIconsStyle.regular),
        'trademark-registered':
            PhosphorIcons.trademarkRegistered(PhosphorIconsStyle.regular),
        'traffic-cone': PhosphorIcons.trafficCone(PhosphorIconsStyle.regular),
        'traffic-sign': PhosphorIcons.trafficSign(PhosphorIconsStyle.regular),
        'traffic-signal':
            PhosphorIcons.trafficSignal(PhosphorIconsStyle.regular),
        'train': PhosphorIcons.train(PhosphorIconsStyle.regular),
        'train-regional':
            PhosphorIcons.trainRegional(PhosphorIconsStyle.regular),
        'train-simple': PhosphorIcons.trainSimple(PhosphorIconsStyle.regular),
        'tram': PhosphorIcons.tram(PhosphorIconsStyle.regular),
        'translate': PhosphorIcons.translate(PhosphorIconsStyle.regular),
        'trash': PhosphorIcons.trash(PhosphorIconsStyle.regular),
        'trash-simple': PhosphorIcons.trashSimple(PhosphorIconsStyle.regular),
        'tray': PhosphorIcons.tray(PhosphorIconsStyle.regular),
        'tree': PhosphorIcons.tree(PhosphorIconsStyle.regular),
        'tree-evergreen':
            PhosphorIcons.treeEvergreen(PhosphorIconsStyle.regular),
        'tree-palm': PhosphorIcons.treePalm(PhosphorIconsStyle.regular),
        'tree-structure':
            PhosphorIcons.treeStructure(PhosphorIconsStyle.regular),
        'trend-down': PhosphorIcons.trendDown(PhosphorIconsStyle.regular),
        'trend-up': PhosphorIcons.trendUp(PhosphorIconsStyle.regular),
        'triangle': PhosphorIcons.triangle(PhosphorIconsStyle.regular),
        'trophy': PhosphorIcons.trophy(PhosphorIconsStyle.regular),
        'truck': PhosphorIcons.truck(PhosphorIconsStyle.regular),
        't-shirt': PhosphorIcons.tShirt(PhosphorIconsStyle.regular),
        'twitch-logo': PhosphorIcons.twitchLogo(PhosphorIconsStyle.regular),
        'twitter-logo': PhosphorIcons.twitterLogo(PhosphorIconsStyle.regular),
        'umbrella': PhosphorIcons.umbrella(PhosphorIconsStyle.regular),
        'umbrella-simple':
            PhosphorIcons.umbrellaSimple(PhosphorIconsStyle.regular),
        'unite': PhosphorIcons.unite(PhosphorIconsStyle.regular),
        'unite-square': PhosphorIcons.uniteSquare(PhosphorIconsStyle.regular),
        'upload': PhosphorIcons.upload(PhosphorIconsStyle.regular),
        'upload-simple': PhosphorIcons.uploadSimple(PhosphorIconsStyle.regular),
        'usb': PhosphorIcons.usb(PhosphorIconsStyle.regular),
        'user': PhosphorIcons.user(PhosphorIconsStyle.regular),
        'user-circle': PhosphorIcons.userCircle(PhosphorIconsStyle.regular),
        'user-circle-gear':
            PhosphorIcons.userCircleGear(PhosphorIconsStyle.regular),
        'user-circle-minus':
            PhosphorIcons.userCircleMinus(PhosphorIconsStyle.regular),
        'user-circle-plus':
            PhosphorIcons.userCirclePlus(PhosphorIconsStyle.regular),
        'user-focus': PhosphorIcons.userFocus(PhosphorIconsStyle.regular),
        'user-gear': PhosphorIcons.userGear(PhosphorIconsStyle.regular),
        'user-list': PhosphorIcons.userList(PhosphorIconsStyle.regular),
        'user-minus': PhosphorIcons.userMinus(PhosphorIconsStyle.regular),
        'user-plus': PhosphorIcons.userPlus(PhosphorIconsStyle.regular),
        'user-rectangle':
            PhosphorIcons.userRectangle(PhosphorIconsStyle.regular),
        'users': PhosphorIcons.users(PhosphorIconsStyle.regular),
        'users-four': PhosphorIcons.usersFour(PhosphorIconsStyle.regular),
        'user-square': PhosphorIcons.userSquare(PhosphorIconsStyle.regular),
        'users-three': PhosphorIcons.usersThree(PhosphorIconsStyle.regular),
        'user-switch': PhosphorIcons.userSwitch(PhosphorIconsStyle.regular),
        'van': PhosphorIcons.van(PhosphorIconsStyle.regular),
        'vault': PhosphorIcons.vault(PhosphorIconsStyle.regular),
        'vibrate': PhosphorIcons.vibrate(PhosphorIconsStyle.regular),
        'video': PhosphorIcons.video(PhosphorIconsStyle.regular),
        'video-camera': PhosphorIcons.videoCamera(PhosphorIconsStyle.regular),
        'video-camera-slash':
            PhosphorIcons.videoCameraSlash(PhosphorIconsStyle.regular),
        'vignette': PhosphorIcons.vignette(PhosphorIconsStyle.regular),
        'vinyl-record': PhosphorIcons.vinylRecord(PhosphorIconsStyle.regular),
        'virtual-reality':
            PhosphorIcons.virtualReality(PhosphorIconsStyle.regular),
        'virus': PhosphorIcons.virus(PhosphorIconsStyle.regular),
        'voicemail': PhosphorIcons.voicemail(PhosphorIconsStyle.regular),
        'volleyball': PhosphorIcons.volleyball(PhosphorIconsStyle.regular),
        'wall': PhosphorIcons.wall(PhosphorIconsStyle.regular),
        'wallet': PhosphorIcons.wallet(PhosphorIconsStyle.regular),
        'warehouse': PhosphorIcons.warehouse(PhosphorIconsStyle.regular),
        'warning': PhosphorIcons.warning(PhosphorIconsStyle.regular),
        'warning-circle':
            PhosphorIcons.warningCircle(PhosphorIconsStyle.regular),
        'warning-diamond':
            PhosphorIcons.warningDiamond(PhosphorIconsStyle.regular),
        'warning-octagon':
            PhosphorIcons.warningOctagon(PhosphorIconsStyle.regular),
        'watch': PhosphorIcons.watch(PhosphorIconsStyle.regular),
        'waveform': PhosphorIcons.waveform(PhosphorIconsStyle.regular),
        'waves': PhosphorIcons.waves(PhosphorIconsStyle.regular),
        'wave-sawtooth': PhosphorIcons.waveSawtooth(PhosphorIconsStyle.regular),
        'wave-sine': PhosphorIcons.waveSine(PhosphorIconsStyle.regular),
        'wave-square': PhosphorIcons.waveSquare(PhosphorIconsStyle.regular),
        'wave-triangle': PhosphorIcons.waveTriangle(PhosphorIconsStyle.regular),
        'webcam': PhosphorIcons.webcam(PhosphorIconsStyle.regular),
        'webcam-slash': PhosphorIcons.webcamSlash(PhosphorIconsStyle.regular),
        'webhooks-logo': PhosphorIcons.webhooksLogo(PhosphorIconsStyle.regular),
        'wechat-logo': PhosphorIcons.wechatLogo(PhosphorIconsStyle.regular),
        'whatsapp-logo': PhosphorIcons.whatsappLogo(PhosphorIconsStyle.regular),
        'wheelchair': PhosphorIcons.wheelchair(PhosphorIconsStyle.regular),
        'wheelchair-motion':
            PhosphorIcons.wheelchairMotion(PhosphorIconsStyle.regular),
        'wifi-high': PhosphorIcons.wifiHigh(PhosphorIconsStyle.regular),
        'wifi-low': PhosphorIcons.wifiLow(PhosphorIconsStyle.regular),
        'wifi-medium': PhosphorIcons.wifiMedium(PhosphorIconsStyle.regular),
        'wifi-none': PhosphorIcons.wifiNone(PhosphorIconsStyle.regular),
        'wifi-slash': PhosphorIcons.wifiSlash(PhosphorIconsStyle.regular),
        'wifi-x': PhosphorIcons.wifiX(PhosphorIconsStyle.regular),
        'wind': PhosphorIcons.wind(PhosphorIconsStyle.regular),
        'windows-logo': PhosphorIcons.windowsLogo(PhosphorIconsStyle.regular),
        'wine': PhosphorIcons.wine(PhosphorIconsStyle.regular),
        'wrench': PhosphorIcons.wrench(PhosphorIconsStyle.regular),
        'x': PhosphorIcons.x(PhosphorIconsStyle.regular),
        'x-circle': PhosphorIcons.xCircle(PhosphorIconsStyle.regular),
        'x-circle-filled': PhosphorIcons.xCircle(PhosphorIconsStyle.fill),
        'x-square': PhosphorIcons.xSquare(PhosphorIconsStyle.regular),
        'yin-yang': PhosphorIcons.yinYang(PhosphorIconsStyle.regular),
        'youtube-logo': PhosphorIcons.youtubeLogo(PhosphorIconsStyle.regular)
      };
}
