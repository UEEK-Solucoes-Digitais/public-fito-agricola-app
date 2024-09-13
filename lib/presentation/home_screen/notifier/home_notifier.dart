import 'package:equatable/equatable.dart';
import 'package:fitoagricola/presentation/home_screen/models/event_item_model.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '/core/app_export.dart';
import '../models/grid_item_model.dart';
import '../models/list_item_model.dart';
import 'package:fitoagricola/presentation/home_screen/models/home_model.dart';
part 'home_state.dart';

final homeNotifier = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(HomeState(
    homeModelObj: HomeModel(
      gridItemList: [
        GridItemModel(
          categoryImg: PhosphorIcons.roadHorizon(),
          category: "Buracos em vias",
        ),
        GridItemModel(
          categoryImg: PhosphorIcons.cube(),
          category: "Entulhos",
        ),
        GridItemModel(
          categoryImg: PhosphorIcons.pawPrint(),
          category: "Animais",
        ),
        GridItemModel(
          categoryImg: PhosphorIcons.lightbulbFilament(),
          category: "Iluminação",
        )
      ],
      listItemList: [
        ListItemModel(
          icon: PhosphorIcons.roadHorizon(),
          title: "Buraco na via",
          description: "Estrada Geral",
          iconStatus: PhosphorIcons.share(),
          status: "Enviada",
          dateText: "09/08/21",
        ),
        ListItemModel(
          icon: PhosphorIcons.pawPrint(),
          title: "Cachorro abandonado",
          description: "Ponte das Laranjeiras",
          iconStatus: PhosphorIcons.dotsThreeOutline(),
          status: "Em análise",
          dateText: "09/08/21",
        ),
        ListItemModel(
          icon: PhosphorIcons.lightbulbFilament(),
          title: "Sem luz no centro 🤡",
          description: "Estrada Geral",
          iconStatus: PhosphorIcons.x(),
          status: "Não encontrada",
          dateText: "09/08/21",
        ),
        ListItemModel(
          icon: PhosphorIcons.trash(),
          title: "Lixo descartado errado demais no petropolis",
          description: "Av. Marechal Deodoro",
          iconStatus: PhosphorIcons.check(),
          status: "Resolvida",
          dateText: "09/08/21",
        )
      ],
      eventItemList: [
        EventItemModel(
            name: 'Startup Wekeend',
            description: "Evento empreendedor",
            location: "Orion Parque",
            date: "10/05/2024",
            image: "https://images.sympla.com.br/64ff29001c231-lg.png"),
      ],
    ),
  )),
);

/// A notifier that manages the state of a Home according to the event that is dispatched to it.
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier(HomeState state) : super(state);
}
