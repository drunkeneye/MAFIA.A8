import random
from utils import *

def split_description(description):
    words = description.split()
    description_parts = []
    current_part = ""
    while  len(words) < 5:
        words.append(" ")
    for word in words:
        if len(current_part) + len(word) < 40:
            current_part += word + " "
        else:
            description_parts.append(current_part.strip())
            current_part = word + " "
    if current_part:
        description_parts.append(current_part.strip())
    print (description_parts)
    if len(description_parts) > 5:
        raise ValueError("Too many description parts (maximum 5 allowed)")
    return description_parts


def create_gangster_file(gangsters, suffix):
    # Create the byte stream
    byte_stream = bytearray()
    for i, gangster in enumerate(gangsters):
        # Extract relevant data from the gangster tuple
        description, name, anrede, sex, str_val, brut, gangster_int, weapon, price = gangster

        # Add the description (cut into pieces of at most 40 characters)
        description_parts = split_description(description)
        while len(description_parts) < 5:
            description_parts.append([' ']);
        for part in description_parts:
            byte_stream.append(len(part))
            part = convert_to_atascii(part)
            byte_stream.extend(part.encode('utf-8').ljust(39, b'\x00'))

        # Add the name and other string
        anrede = convert_to_atascii(anrede)
        byte_stream.append(len(anrede))
        byte_stream.extend(anrede.encode('utf-8').ljust(15, b'\x00'))

        # Add the remaining values
        byte_stream.append(sex)
        byte_stream.append(str_val)
        byte_stream.append(brut)
        byte_stream.append(gangster_int)
        byte_stream.append(weapon)
        if len(name) > 15:
            raise Exception (f"This name is too long {name}")
        byte_stream.append(len(name))
        name = convert_to_atascii(name)
        byte_stream.extend(name.encode('utf-8').ljust(15, b'\x00'))
        byte_stream.extend(price.to_bytes(2, byteorder='little'))  # Save price in little-endian order

        # put each gangster into a block of 256 bytes
        remainder = len(byte_stream) % 256
        if remainder != 0:
            zeros_to_add = 256 - remainder
        byte_stream.extend([0] * zeros_to_add)

    # Write the byte stream to the file
    filename = f"../assets/gangstas.dat_{suffix}"
    with open(filename, 'wb') as f:
        f.write(byte_stream)



gangsters_data_DE = [
    # 1-5
    ("Ein hagerer Typ in einem schwarzen Anzug, dem einem Geruch nach Leichen anklebt, "
     "starrt dich aus Glupschaugen an. Er heisst Johnny und will mit dir "
     "Leute beerdigen gehen.",
     "Johnny", "ihn", 0, 40, 50, 25, 5, 2000),
    ("Ein verschlagener Typ in schaebigen Klamotten bittet dich, ihm ein Bier auszugeben. "
     "Die Leute nennen ihn Killer Jack, und so will er auch genannt werden. "
     "Fuer kleines Geld hilft er dir.",
     "Killer Jack", "ihn", 0, 30, 30, 45, 2, 1500),
    ("In einer Ecke versucht ein schmaechtiger Kerl die Zeitung von gestern zu lesen."
     "Er hat ein duemmliches Gesicht und scheint ueberfordert. "
     "Der koennte hilfreich sein.",
     "Joe, das Hirn", "ihn", 0, 30, 30, 20, 1, 1000),
    ("Ein Typ mit fettigen roten Haaren mit einer billigen Gitarre kommt in den Pub. "
     "Die Leute kriegen schon vom blossen Anblick Angst. "
     "Er kennt keine Gnade.",
     "Barden Eddie", "ihn", 0, 20, 50, 25, 3, 1700),
    ("An der Bar steht eine derbe, brutal aussehende Frau, die aus ihren schwarz "
     "angemalten Augen den typischen Killer Blick hat. "
     "Keiner kann ihr widerstehen.",
     "Bloody Mary", "sie", 1, 60, 10, 40, 3, 2300),

    # 6-10
    ("Ein grosser, muskuloeser Mann mit einer Narbe im Gesicht und einem Goldzahn "
     "grinst dich an. Er nennt sich Big Tony. "
     "Er hat immer einen Baseballschlaeger dabei.",
     "Big Tony", "ihn", 0, 70, 20, 35, 4, 2500),
     ("Eine schlanke, blonde Frau in einem roten Kleid und hohen Schuhen "
      "zwinkert dir zu. Sie heisst Lola und ist eine Meisterin der Verfuehrung."
      "Sie kann jeden um den Finger wickeln.",
      "Lola", "sie", 1, 30, 40, 60, 0, 2200),
    ("Ein kleiner, dicker Mann mit einer Hornbrille und einem Schnurrbart "
      "sitzt an einer Zuendvorrichtung. Er heisst Gonzo und ist ein Genie im "
      "Umgang mit Bomben. ",
      "Gonzo", "ihn", 0, 10, 10, 80, 0, 1800),
    ("Ein junger, drahtiger Kerl mit einer Lederjacke und einer Sonnenbrille "
     "lehnt an einer Wand. Er heisst Spike und ist ein Draufgaenger. "
     "Er liebt es, Autos zu klauen.",
     "Spike", "ihn", 0, 40, 40, 40, 2, 1900),
     ("Eine dunkelhaarige Frau in einem schwarzen Mantel und einer Pistole im Guertel "
      "schaut dich kalt an. Sie heisst Viper und trifft immer ins Schwarze.",
      "Viper", "sie", 1, 50, 60, 50, 6, 2600),

      # 11-15
      ("Ein alter, grauhaariger Mann mit einem Gehstock und einem Zylinder "
       "nickt dir freundlich zu. Er heisst Old Joe und ist ein erfahrener Gauner. "
       "Er kennt alle Tricks und Kniffe.",
       "Old Joe", "ihn", 0, 20, 20, 70, 0, 1600),
       ("Eine rothaarige Frau in einem gruenen Kleid und einem Hut "
        "laechelt dich an. Sie heisst Ginger und ist eine Gluecksbringerin. "
        "Sie hat immer ein Ass im Aermel.",
        "Ginger", "sie", 1, 30, 30, 50, 0, 2000),
       ("Ein riesiger, glatzkoepfiger Mann mit einem Tattoo auf dem Arm und "
        "einem Messer in der Hand brummt dich an. Er heisst Brutus und "
        "macht kurzen Prozess mit jedem, der ihm in die Quere kommt.",
        "Brutus", "ihn", 0, 80, 70, 10, 5, 2700),
       ("Eine huebsche, bruenette Frau in einem blauen Anzug und einer Brille "
        "gruesst dich hoeflich. Sie ist Rechtsverdreherin und kann "
        "mit Paragraphen um sich werfen.",
        "Lisa", "sie", 1, 20, 20, 60, 0, 2100),
        ("Ein schlanker, braunhaariger Mann in einem weissen Hemd und einer Krawatte "
         "gibt dir die Hand. Er heisst Mike und "
         "kann jeden ueber den Tisch ziehen.",
         "Mike", "ihn", 0, 30, 40, 55, 0, 2000),

        # 16-20
        ("Eine mollige, blonde Frau in einem rosa Pullover winkt dir zu. "
         "Sie heisst Betty und ist eine Fahrerin. " "Sie kann mit jedem Fahrzeug Gas geben.",
         "Betty", "sie", 1, 40, 30, 40, 1, 1800),
         ("Ein mittelgrosser, schwarzhaariger Mann in einem grauen Anzug und einem Hut "
          "raucht eine Zigarette. Er heisst Sam war mal Detektiv. "
          "Er kann jeden Fall loesen.",
          "Sam", "ihn", 0, 40, 50, 60, 3, 2400),
        ("Eine kleine, zierliche Frau in einem gelben Kleid und einem Schal "
          "singt ein Lied. Sie heisst Tina und ist eine Sirene. "
          "Sie kann jeden betoeren.",
          "Tina", "sie", 1, 20, 40, 50, 0, 1900),
        ("Ein dicker, rothaariger Mann in einem gruenen Pullover und einer Hose "
         "isst einen Donut. Er heisst Bob und ist ein Informant. "
         "Er weiss alles, was in der Stadt passiert.",
         "Bob", "ihn", 0, 10, 20, 40, 0, 1200),
         ("Eine grosse, athletische Frau in einem schwarzen Lederanzug und einer Maske "
          "schmiegt sich an dich. Sie heisst Cat und "
          "kann alles stehlen, was du willst.",
          "Cat", "sie", 1, 60, 60, 60, 4, 2800),

        # 21-25
        ("Ein kleiner, schmaler Mann in einem braunen Mantel und einem Schal "
         "haelt einen Koffer. Er heisst Tim und ist ein Sprengstoffexperte. "
         "Er kann alles in die Luft jagen.",
         "Tim", "ihn", 0, 20, 40, 40, 6, 1900),
         ("Eine mittelgrosse, dunkelhautige Frau in einem roten Mantel und einem Hut "
          "traegt eine Tasche. Sie heisst Ruby und ist eine Hehlerin. "
          "Sie kann alles verticken, was du anschleppst.",
          "Ruby", "sie", 1, 30, 30, 45, 0, 1700),
        ("Ein grosser, blonder Mann in einem blauen Anzug und einer Fliege "
         "laechelt dich an. Er heisst James und ist ein Spion. "
         "Er kann sich in jede Situation einpassen.",
         "James", "ihn", 0, 50, 50, 70, 6, 3000),
         ("Eine schmale, asiatische Frau in einem weissen Kleid und einer Perlenkette "
          "verbeugt sich vor und gibt ihr ihre eiskalte Hand, die dir das Blut "
          "gefrieren laesst",
          "Mei", "sie", 1, 20, 30, 50, 4, 3200),
        ("Ein geheimnisvoller Kerl tippt dir ploetzlich auf die Schulter. "
         "Niemand weiss, welche Faehigkeiten er wirklich besitzt.",
         "Garry G", "ihn", 0, 30, 10, 60, 0, 2500),

         # 26-30
        ("Da ist Zocker-Alf, Meister der Spielhoelle, beherrscht nicht nur das Gluecksspiel "
        "sondern hat auch andere Talente. Vermutlich.",
        "Zocker-Alf", "ihn", 0, 5, 80, 65, 0, 2300),
        ("Der Barkeeper stellt dir Pistolen-Henry vor, vielleicht nicht der Schlauste, "
        "aber definitiv gefuerchtet fuer seine akrobatischen Schuesse.",
        "Pistolen-Henry", "ihn", 0, 40, 15, 60, 6, 3100),
        ("Jeff Smart sieht aus wie aus einem Comic entsprungen, aber unterschaetze ihn nicht. "
         "Er schafft es, jedem den letzten Nerv zu rauben.",
         "Jeff Smart", "ihn", 0, 40, 80, 15, 0, 2300),
        ("Fred Clever, ein wandlungsfaehiger Ganove, ist bereit, all seine Freunde zu opfern. "
         "Fuer eine kleine Entlohnung, versteht sich.",
         "Fred Clever", "ihn", 0, 10, 85, 50, 0, 2300),
        ("Ein undurchsichtiger Blick hinter einer undurchsichtigen Brille. "
         "Poker-Face ist mehr als nur ein geschickter Kartenspieler.",
         "Poker-Face", "ihn", 0, 40, 60, 90, 0, 2300),

        # 31-32
        ("Prediger Samuel, ein dicker, gutmuetig wirkender Mann, aber hat seiner "
         "Rosenkette schon viele Polizisten blutigen Staub fressen lassen.",
         "Prediger Samuel", "ihn", 0, 55, 60, 10, 0, 2300),
        ("Mister X, gehuellt in Schwarz, ist eine undurchsichtige Gestalt im Dunkel der Nacht. "
         "Angeblich kennt er sich bestens aus in der UBahn von London.",
        "Mister X", "ihn", 0, 30, 45, 60, 6, 3000)
]


gangsters_data_EN = [
    # 1-5
    ("A lean guy in a black suit, with a smell of corpses clinging to him, "
     "stares at you with bulging eyes. His name is Johnny and he wants to go burying people with you.",
     "Johnny", "him", 0, 40, 50, 25, 5, 2000),
    ("A sly guy in shabby clothes asks you to buy him a beer. "
     "People call him Killer Jack, and that's how he wants to be called. "
     "For a small fee, he'll help you out.",
     "Killer Jack", "him", 0, 30, 30, 45, 2, 1500),
    ("In a corner, a skinny guy tries to read yesterday's newspaper. "
     "He has a dumb face and seems overwhelmed. "
     "He could be helpful.",
     "Joe, the Brain", "him", 0, 30, 30, 20, 1, 1000),
    ("A guy with greasy red hair and a cheap guitar walks into the pub. "
     "People get scared just by the sight of him. "
     "He shows no mercy.",
     "Bard Eddie", "him", 0, 20, 50, 25, 3, 1700),
    ("At the bar stands a rough, brutal-looking woman, her eyes painted black "
     "staring at you with the typical killer gaze. "
     "No one can resist her.",
     "Bloody Mary", "her", 0, 60, 10, 40, 3, 2300),

    # 6-10
    ("A big, muscular guy with a scar on his face and a gold tooth "
     "grins at you. He calls himself Big Tony. "
     "He always carries a baseball bat.",
     "Big Tony", "him", 0, 70, 20, 35, 4, 2500),
     ("A slender, blonde woman in a red dress and high heels "
      "winks at you. Her name is Lola and she's a seduction master."
      "She can wrap anyone around her finger.",
      "Lola", "her", 1, 30, 40, 60, 0, 2200),
    ("A short, chubby man with horn-rimmed glasses and a mustache "
      "sits at a detonator. His name is Gonzo and he's a bomb handling genius. ",
      "Gonzo", "him", 0, 10, 10, 80, 0, 1800),
    ("A young, wiry guy in a leather jacket and sunglasses "
     "leans against a wall. His name is Spike and he's a daredevil. "
     "He loves stealing cars.",
     "Spike", "him", 0, 40, 40, 40, 2, 1900),
     ("A dark-haired woman in a black coat with a gun in her belt "
      "gazes at you coldly. Her name is Viper and she always hits the mark.",
      "Viper", "her", 1, 50, 60, 50, 6, 2600),

      # 11-15
      ("An old, gray-haired man with a cane and a top hat "
       "nods at you kindly. His name is Old Joe and he's an experienced crook. "
       "He knows all the tricks.",
       "Old Joe", "him", 0, 20, 20, 70, 0, 1600),
       ("A red-haired woman in a green dress and a hat "
        "smiles at you. Her name is Ginger and she's a lucky charm. "
        "She always has an ace up her sleeve.",
        "Ginger", "her", 1, 30, 30, 50, 0, 2000),
       ("A huge, bald-headed man with a tattoo on his arm and "
        "a knife in his hand growls at you. His name is Brutus and "
        "he makes short work of anyone who gets in his way.",
        "Brutus", "him", 0, 80, 70, 10, 5, 2700),
       ("A pretty, brunette woman in a blue suit and glasses "
        "greets you politely. She's a legal shark and can "
        "throw around legal jargon.",
        "Lisa", "her", 1, 20, 20, 60, 0, 2100),
        ("A slim, brown-haired man in a white shirt and a tie "
         "shakes your hand. His name is Mike and "
         "he can swindle anyone.",
         "Mike", "him", 0, 30, 40, 55, 0, 2000),

        # 16-20
        ("A chubby, blonde woman in a pink sweater waves at you. "
         "Her name is Betty and she's a driver. " "She can speed in any vehicle.",
         "Betty", "her", 1, 40, 30, 40, 1, 1800),
         ("A medium-sized, black-haired man in a gray suit and a hat "
          "smokes a cigarette. His name is Sam and he used to be a detective. "
          "He can solve any case.",
          "Sam", "him", 0, 40, 50, 60, 3, 2400),
        ("A small, petite woman in a yellow dress and a scarf "
          "sings a song. Her name is Tina and she's a siren. "
          "She can enchant anyone.",
          "Tina", "her", 1, 20, 40, 50, 0, 1900),
        ("A chubby, red-haired man in a green sweater and pants "
         "eats a donut. His name is Bob and he's an informant. "
         "He knows everything that happens in the city.",
         "Bob", "him", 0, 10, 20, 40, 0, 1200),
         ("A tall, athletic woman in a black leather suit and a mask "
          "snuggles up to you. Her name is Cat and "
          "she can steal anything you want.",
          "Cat", "her", 1, 60, 60, 60, 4, 2800),

        # 21-25
        ("A small, slim man in a brown coat and a scarf "
         "holds a briefcase. His name is Tim and he's an explosives expert. "
         "He can blow anything up.",
         "Tim", "him", 0, 20, 40, 40, 6, 1900),
         ("A medium-sized, dark-skinned woman in a red coat and a hat "
          "carries a bag. Her name is Ruby and she's a fence. "
          "She can sell anything you bring her.",
          "Ruby", "her", 1, 30, 30, 45, 0, 1700),
        ("A tall, blond man in a blue suit and a bow tie "
         "smiles at you. His name is James and he's a spy. "
         "He can blend into any situation.",
         "James", "him", 0, 50, 50, 70, 6, 3000),
         ("A slender, Asian woman in a white dress and a pearl necklace "
          "bows to you and gives you her ice-cold hand, making your blood "
          "run cold",
          "Mei", "her", 1, 20, 30, 50, 4, 3200),
        ("A mysterious guy suddenly taps you on the shoulder. "
         "No one knows what skills he truly possesses.",
         "Garry G", "him", 0, 30, 10, 60, 0, 2500),

         # 26-30
        ("There's Alf the Gambler, master of the gambling den, not only skilled in "
        "games of chance but with other talents too. Supposedly.",
        "Alf the Gambler", "him", 0, 5, 80, 65, 0, 2300),
        ("The bartender introduces you to Pistol-Henry, maybe not the brightest, "
        "but definitely feared for his acrobatic shots.",
        "Pistol-Henry", "him", 0, 40, 15, 60, 6, 3100),
        ("Jeff Smart looks like he's stepped out of a comic book, but don't underestimate him. "
         "He manages to get on everyone's last nerve.",
         "Jeff Smart", "him", 0, 40, 80, 15, 0, 2300),
        ("Fred Clever, a versatile crook, is ready to sacrifice all his friends. "
         "For a small fee, of course.",
         "Fred Clever", "him", 0, 10, 85, 50, 0, 2300),
        ("An inscrutable gaze behind inscrutable glasses. "
         "Poker-Face is more than just a skilled card player.",
         "Poker-Face", "him", 0, 40, 60, 90, 0, 2300),

        # 31-32
        ("Preacher Samuel, a chubby, kind-looking man, but with his "
         "rosary has made many policemen eat bloody dust.",
         "Preacher Samuel", "him", 0, 55, 60, 10, 0, 2300),
        ("Mister X, cloaked in black, is a mysterious figure in the darkness of the night. "
         "Supposedly, he knows the London Underground like the back of his hand.",
        "Mister X", "him", 0, 30, 45, 60, 6, 3000)
]


gangsters_data_PL = [
    # 1-5
    ("Wychudly facet w czarnym garniturze smierdzi trupami i gapi sie na ciebie "
     "swymi wylupiastymi oczami. Nazywa sie Johnny i chce isc z toba grzebac ludzi.",
     "Johnny", "go", 0, 40, 50, 25, 5, 2000),
    ("Przebiegly typek w podniszczonych ciuchach prosi cie o kupienie mu piwa. "
     "Ludzie mowia na niego Killer Jack i tak tez chce byc nazywany. "
     "Pomoze ci za niewielka oplata.",
     "Killer Jack", "go", 0, 30, 30, 45, 2, 1500),
    ("W kacie jakis chudzielec probuje czytac wczorajsza gazete. "
     "Ma glupkowata mine i wydaje sie byc przytloczony. "
     "Moglby byc pomocny.",
     "Joe 'Mozg'", "go", 0, 30, 30, 20, 1, 1000),
    ("Do pubu wchodzi gosc z tlustymi rudymi wlosami i tania gitara. "
     "Sam jego widok budzi strach u ludzi. Nie zna litosci. ",
     "Eddie Bard", "go", 0, 20, 50, 25, 3, 1700),
    ("Przy barze stoi kobieta, wyglada na twarda i brutalna. "
     "Posyla zabojcze spojrzenia umalowanymi na czarno oczami. "
     "Nikt nie moze sie jej oprzec.",
     "Krwawa Mary", "ja", 1, 60, 10, 40, 3, 2300),

    # 6-10
    ("Wysoki, muskularny koles z blizna na twarzy i zlotym zebem "
     "usmiecha sie do ciebie. Nazywa siebie Duzym Tonym. "
     "Zawsze ma przy sobie kij bejsbolowy.",
     "Duzy Tony", "go", 0, 70, 20, 35, 4, 2500),
     ("Mruga do ciebie szczupla blondynka w czerwonej sukience "
      "i w szpilkach. Nazywa sie Lola i jest mistrzynia uwodzenia."
      "Umie kazdego owinac sobie wokol palca.",
      "Lola", "ja", 1, 30, 40, 60, 0, 2200),
    ("Maly grubasek ma okulary w rogowych oprawkach, wasy "
      "i siedzi z detonatorem. Nazywa sie Gonzo i jest geniuszem "
      "w poslugiwaniu sie bombami.",
      "Gonzo", "go", 0, 10, 10, 80, 0, 1800),
    ("Mlody, zylasty facet w skorzanej kurtce i okularach przeciwslonecznych "
     "opiera sie o sciane. Ma na imie Spike i jest ryzykantem. "
     "Uwielbia krasc samochody.",
     "Spike", "go", 0, 40, 40, 40, 2, 1900),
     ("Ciemnowlosa panna w czarnym plaszczu i z pistoletem za pasem "
      "patrzy na ciebie chlodno. Znana jest jako Zmija i zawsze trafia w dziesiatke.",
      "Zmija", "ja", 1, 50, 60, 50, 6, 2600),

      # 11-15
      ("Siwowlosy staruszek z laska i cylindrem kiwa ci uprzejmie glowa. "
       "Nazywa sie Stary Joe i jest doswiadczonym oszustem. "
       "Zna wszystkie sztuczki.",
       "Stary Joe", "go", 0, 20, 20, 70, 0, 1600),
       ("Usmiecha sie do ciebie rudowlosa kobieta w zielonej sukience i kapeluszu. "
        "Ma na imie Ginger i przynosi szczescie. "
        "Zawsze ma asa w rekawie.",
        "Ginger", "ja", 1, 30, 30, 50, 0, 2000),
       ("Olbrzymi, lysy mezczyzna z tatuazem na ramieniu i nozem w reku "
        "warczy na ciebie. Nazywa sie Brutus i szybko radzi sobie "
        "z kazdym, kto stanie mu na drodze.",
        "Brutus", "go", 0, 80, 70, 10, 5, 2700),
       ("Ladna brunetka w niebieskim garniturze i okularach "
        "grzecznie cie wita. Jest milosniczka prawa i potrafi "
        "z latwoscia rzucac paragrafami.",
        "Lisa", "ja", 1, 20, 20, 60, 0, 2100),
        ("Szczuply szatyn w bialej koszuli i w krawacie "
         "podaje ci reke. Uzywa imienia Mike "
         "i potrafi wszystkich oszukac.",
         "Mike", "go", 0, 30, 40, 55, 0, 2000),

        # 16-20
        ("Pulchna blondynka w rozowym swetrze macha do ciebie. "
         "Nazywa sie Betty i jest kierowca. " "Potrafi palic gume w kazdym pojezdzie.",
         "Betty", "ja", 1, 40, 30, 40, 1, 1800),
         ("Sredniej wielkosci brunet w szarym garniturze i kapeluszu "
          "pali papierosa. Nazywa sie Sam i byl kiedys detektywem. "
          "Jest w stanie rozwiazac kazda sprawe.",
          "Sam", "go", 0, 40, 50, 60, 3, 2400),
        ("Mala, drobna kobieta w zoltej sukni i szalu "
          "spiewa piosenke. Nazywa sie Tina i jest wampem. "
          "Potrafi oczarowac kazdego.",
          "Tina", "ja", 1, 20, 40, 50, 0, 1900),
        ("Otyly rudzielec w zielonym swetrze i spodniach "
         "zajada sie paczkiem. Na imie ma Bob i jest informatorem. "
         "Wie wszystko, co dzieje sie w miescie.",
         "Bob", "go", 0, 10, 20, 40, 0, 1200),
         ("Wysoka, atletyczna kobieta w czarnym skorzanym stroju i masce "
          "przytula sie do ciebie. Nazywa sie Kotka "
          "i potrafi ukrasc wszystko, czego zapragniesz.",
          "Kotka", "ja", 1, 60, 60, 60, 4, 2800),

        # 21-25
        ("Niski, szczuply mezczyzna w brazowym plaszczu i szaliku "
         "trzyma walizke. To Tim, ekspert od materialow wybuchowych. "
         "Umie wszystko wysadzic w powietrze.",
         "Tim", "go", 0, 20, 40, 40, 6, 1900),
         ("Sredniej wielkosci ciemnoskora kobieta w czerwonym plaszczu i kapeluszu "
          "nosi ze soba torbe. Nazywa sie Ruby i jest paserka. "
          "Moze sprzedac wszystko, co przyniesiesz.",
          "Ruby", "ja", 1, 30, 30, 45, 0, 1700),
        ("Wysoki blondyn w niebieskim garniturze i muszce "
         "usmiecha sie do ciebie. Na imie ma James i jest szpiegiem. "
         "Potrafi wpasowac sie w kazda sytuacje.",
         "James", "go", 0, 50, 50, 70, 6, 3000),
         ("Smukla Azjatka w bialej sukience i naszyjniku z perel "
          "klania ci sie i podaje swoja zimna dlon, ktora sprawia, ze krew ci zamarza",
          "Mei", "ja", 1, 20, 30, 50, 4, 3200),
        ("Tajemniczy gosc nagle klepie cie w ramie. "
         "Nikt nie wie, jakie umiejetnosci naprawde posiada.",
         "Garry G", "go", 0, 30, 10, 60, 0, 2500),

         # 26-30
        ("Hazardzista Alf, mistrz salonu gier, nie tylko opanowal sztuke hazardu, "
        "ale ma tez inne talenty. Prawdopodobnie.",
        "Hazardzista Alf", "go", 0, 5, 80, 65, 0, 2300),
        ("Barman przedstawia ci Pistoletowego Henry'ego, moze nie najmadrzejszego, "
        "ale zdecydowanie budzacego strach ze wzgledu na swoje akrobatyczne strzaly.",
        "Henry Pistolet", "go", 0, 40, 15, 60, 6, 3100),
        ("Jeff Smart wyglada jakby wyszedl prosto z komiksu, ale nie lekcewaz go. "
         "Potrafi doprowadzic kazdego do szalu.",
         "Jeff Smart", "go", 0, 40, 80, 15, 0, 2300),
        ("Fred Clever, wszechstronny zloczynca, gotow jest poswiecic wszystkich swoich przyjaciol. "
         "Za malym wynagrodzeniem, rzecz jasna.",
         "Fred Clever", "go", 0, 10, 85, 50, 0, 2300),
        ("Skryte spojrzenie zza ciemnych okularow. "
         "Poker-Face to wiecej niz tylko zreczny gracz w karty.",
         "Poker-Face", "go", 0, 40, 60, 90, 0, 2300),

        # 31-32
        ("Ksiadz Samuel to pulchny, dobroduszny czlowiek, ale jego "
         "rozaniec sprawil, ze juz wielu policjantow gryzie krwawy piach.",
         "Ksiadz Samuel", "go", 0, 55, 60, 10, 0, 2300),
        ("Mister X, ubrany na czarno, to tajemnicza postac w ciemnosciach nocy. "
         "Najwyrazniej doskonale zna metro w Londynie.",
        "Mister X", "go", 0, 30, 45, 60, 6, 3000)
]


create_gangster_file(gangsters_data_DE, "DE")
create_gangster_file(gangsters_data_EN, "EN")
create_gangster_file(gangsters_data_PL, "PL")
