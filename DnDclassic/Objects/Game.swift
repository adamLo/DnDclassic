//
//  Game.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation
import UIKit

struct Game {
    
    let intro: String
    let scenes: [Scene]
    let cover: UIImage
    
    init() {
        
        intro = """
        Egyetlen helyes út vezet el a Varázsló útvesztőjén
        keresztül, és csak többszöri próbálkozásra találod azt
        meg. Jegyzetelj és készíts térképet utad során, ez
        felbecsülhetetlen értékű lesz az elkövetkező kalandjaidban,
        és segít, hogy gyorsan keresztüljuss a felderítetlen
        részeken.
        Nem minden szoba rejt kincseket. Sokszor csupán
        csapdák vagy olyan lények várnak rád, melyekkel
        összeütközésbe kerülsz. Sok hamis nyom van, és
        még ha sikerrel jutsz is át a Labirintuson, csak akkor
        kaparinthatod meg a Varázsló kincsét, ha útközben
        bizonyos tárgyakra szert teszel.
        Sokféle kulcsot találsz majd a Labirintus szobáiban,
        de csak akkor tudod a Varázsló ládáját kinyitni, és
        megszerezni kincsét, ha rendelkezel a megfelelő kulcsokkal…
        Nem egyszer csalódás fog érni a hegy belsejében.
        Az egyetlen igazi út minimális kockázatot jelent, és
        minden játékos, függetlenül attól, milyen pontokkal
        vág neki, elég könnyen végigmehet rajta.
        Kísérjen szerencse kalandjaid során! Sok sikert!
        """
        
        cover = UIImage(named: "cover.png")!
        scenes = [
            Game.prologue,
            Game.scene_001, Game.scene_002, Game.scene_003, Game.scene_004
        ]
    }
    
    private static var prologue: Scene {
        
        let story = """
        Csak egy vakmerő kalandor vágna bele egy ilyen
        veszélyes vállalkozásba - mint ez a kincskeresés -
        anélkül, hogy előtte ne próbálna meg minden
        lehetségeset megtudni a hegyről és a kincsről. Mielőtt
        elmennél a Tűzhegy birodalmába, néhány napot egy
        környékbeli falu lakosai között töltesz vagy kétnapnyi
        járásra a hegytől. Mivel rokonszenves vagy nekik,
        könnyen kapcsolatba kerülsz a helyi parasztokkal. Bár
        sokféle történetet mesélnek el neked a titokzatos Varázslóról
        és rejtekhelyéről, egyáltalán nem vagy benne
        biztos, hogy a történetek mindegyike, vagy akár
        csak egy is, valóban igaz-e. A falusiak sok kalandvágyó
        embert láttak már a hegyhez vezető úton, de közülük
        csak nagyon kevesen tértek vissza. Most már
        biztosan tudod, hogy az előtted álló Út különösen
        veszedelmes lesz. Azok közül, akik vissza- jutottak a
        faluba, még senki sem kísérelte meg, hogy visszamerészkedjen
        a hegyhez.
        Úgy érzed, elképzelhető, hogy valóban létezik a Varázsló,
        és hogy a kincseit egy pompás ládában rejtegeti,
        és melynek kulcsait különféle lények őrzik az
        útvesztőben. A Varázsló hatalmas mágikus erővel
        rendelkezik. Egyesek szerint fiatal, mások szerint
        Öreg. Néhányan úgy vélik, erejét egy csomag bűvös
        kártyából meríti, mások azt vallják, hatalmát a kezén
        viselt fekete selyemkesztyű adja.
        A hegy gyomrába vezető bejáratot egy csapat bibircsókos
        arcú Goblin őrzi. Ezeket a buta teremtményeket
        nem érdekli más, csak az eszem-iszom. Továbbjutva,
        a belső kamrákban már jóval félelmetesebb
        lények vannak. Ahhoz, hogy a belső termekbe el lehessen
        jutni, át kell kelni egy folyón. A kompszolgálat
        rendszeres, de a révész ingyen nem visz át, úgyhogy
        néhány aranyat félre kell tenned, ha át akarsz kelni a
        folyón. A helyiek azt is tanácsolják, hogy vezess térképet
        kóborlásaidról, mert enélkül reménytelenül el
        fogsz tévedni a hegy belsejében.
        Mikor az indulás napja elérkezik, az egész falu aprajanagyja
        megjelenik, hogy szerencsés utat kívánjon
        neked. Nem egy nőnek - fiatalnak, öregnek egyaránt -
        könny csillog a szemében. Nem tudsz szabadulni a
        gondolattól, hogy ezek a részvét könnyei, s olyan
        szemekben csillognak, melyeket tán sohasem látsz
        viszont...
        """
        
        let waypoint = WayPoint(direction: .unkown, destinationId: 1, text: "És most lapozz!")
        
        return Scene(id: 0, story: story, wayPoints: [waypoint])
    }
    
    private static var scene_001: Scene {
        
        let image = UIImage(named: "scene_001")
        
        let story = """
        Véget ért a kétnapi gyaloglás. Kihúzod hüvelyéből a
        kardodat, a földre fekteted, és megkönnyebbülten
        felsóhajtasz, amint leülsz, hogy a mohalepte sziklának
        dőlve pihenj egy percet. Kinyújtózol, megdörzsölöd
        szemedet, és végül felpillantasz.
        Már maga a hegy is fenyegetőnek látszik. A meredek
        hegyoldal olyan előtted, mintha egy hatalmas óriás
        karmai marcangolták volna szét. Éles sziklák, kőszirtek
        meredeznek belőle szinte természetellenes módon.
        A hegy tetejét hátborzongatóan furcsa vörös
        színű valami borítja - talán egy különös növény -‚
        melynek színéről kapta nevét a hegy. Lehet, hogy
        soha senki sem fogja megtudni pontosan, mi is az,
        ami ott nő, mert felmászni a csúcsra egészen biztosan
        lehetetlen.
        A titok megfejtése rád vár. A tisztással szemben egy
        barlang bejárata sötétlik. Felemeled a kardod, a lábadhoz
        támasztod, és számba veszed, milyen veszélyek
        leselkedhetnek rád, ha továbbmész. De aztán
        eltökélten a hüvelyébe lököd a kardod, és nekivágsz a
        barlangnak.
        Mereven belebámulsz a homályba, és sötét, nyálkás
        falakat pillantasz meg. A lábad előtti kőpadlón pocsolyákba
        folyik össze a víz. A levegő hűvös és nyirkos.
        Meggyújtod a lámpásodat, és óvatosan bemerészkedsz
        a sötétségbe. Pókhálók súrolják arcodat, apró
        lábak surranó lépéseit hallod - valószínűleg patkányok.
        Nekivágsz a barlangnak. Néhány méter után
        egy elágazáshoz érsz.
        """
        
        let wpWest = WayPoint(direction: .west, destinationId: 71, text: "Ha nyugat felé indulsz")
        let wpEast = WayPoint(direction: .east, destinationId: 278, text: "ha kelet felé")
        
        return Scene(id: 1, story: story, image: image, wayPoints: [wpEast, wpWest])
    }
    
    private static var scene_002: Scene {
        
        let story = """
        Tedd próbára Szerencséd! Ha szerencsés vagy, el
        tudsz menekülni anélkül, hogy felhívnád magadra az
        Ogre figyelmét. Ha nincs szerencséd, belerúgsz egy
        apró kőbe, amely végiggurul a barlangon, és elkáromkodod
        magad. Kihúzod hüvelyéből a kardodat arra az
        esetre, ha az Ogre meghallaná a zajt.
        Ha szerencsédre a zaj elkerülte a figyelmét, óvatosan
        másszál vissza a folyosón, egészen a keresztútig.
        """
        
        let wpGoodLuck = WayPoint(direction: .backup, destinationId: 269, text: "A zaj elkerülte a figyelmét")
        let wpBadLuck = WayPoint(direction: .east, destinationId: 16, text: "Az Ogre meghallotta a zajt")
        let action: Action = .tryLuck(success: wpGoodLuck, failure: wpBadLuck)
        
        return Scene(id: 2, story: story, actions: [action])
    }
    
    private static var scene_003: Scene {
        
        let story = """
        A csengő tompa hangon megzendül, és néhány pillanat
        múlva megpillantasz egy ráncos, öreg embert, aki
        bemászik egy kis evezős csónakba, amely az északi
        oldalon horgonyoz. Az Öreg lassan átevez hozzád,
        kiköti a csónakot, és feléd sántikál. Három aranypénzt
        kér tőled. Amikor megdöbbensz az ár hallatán, csak
        ennyit morog mentségéül: - Infláció van. - Viszont
        kezd méregbe gurulni a tiltakozásod miatt.
        """
        
        let wp1 = WayPoint(direction: .unkown, destinationId: 272, text: "Megfizeted neki a három aranyat")
        let wp2 = WayPoint(direction: .east, destinationId: 127, text: "Megfenyegeted")
        
        return Scene(id: 3, story: story, wayPoints: [wp1, wp2])
    }
    
    private static var scene_004: Scene {
        
        let story = """
        Egy észak-dél irányú folyosón találod magad.
        """
        
        let wp1 = WayPoint(direction: .north, destinationId: 46, text: "Északnak indulsz, ahonnan egy idő után kelet felé kanyarodik el az út")
        let wp2 = WayPoint(direction: .south, destinationId: 332, text: "Dél felé veszed az utad, ahonnan szintén keletnek visz az út, néhány méter megtétele után")
        
        return Scene(id: 4, story: story, wayPoints: [wp1, wp2])
    }
}
