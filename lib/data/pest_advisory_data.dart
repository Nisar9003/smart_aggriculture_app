/// Static knowledge base of common pests/diseases per crop, with
/// recommended pesticide/spray. This is standard agriculture-extension
/// level information (the kind published by Pakistan's agriculture
/// departments across a full growing season), not a live "Google
/// search" — that would need a paid search API. Kept in-app so it
/// works offline and instantly, and is comprehensive per crop.
class PestInfo {
  final String name;
  final String symptoms;
  final String pesticide;
  final String dosageNote;

  const PestInfo({
    required this.name,
    required this.symptoms,
    required this.pesticide,
    required this.dosageNote,
  });
}

const _wheatIssues = [
  PestInfo(
    name: "Zangar - Peela (Yellow Rust)",
    symptoms: "Pattoon par peele/narangi lakeer numa dhabbe",
    pesticide: "Propiconazole 25% EC (jese Tilt)",
    dosageNote: "1 ml per litre pani, pehli alamat par turant spray karein",
  ),
  PestInfo(
    name: "Zangar - Bhura (Brown/Leaf Rust)",
    symptoms: "Pattoon par bikhray hue bhoore dhabbe",
    pesticide: "Propiconazole 25% EC ya Mancozeb",
    dosageNote: "1 ml (ya 2.5g Mancozeb) per litre pani",
  ),
  PestInfo(
    name: "Karnal Bunt",
    symptoms: "Danon mein kaali phaphoondi, machli jaisi badbu",
    pesticide: "Propiconazole spray phool ki stage par (preventive)",
    dosageNote: "1 ml per litre, boot-leaf stage par spray karein",
  ),
  PestInfo(
    name: "Loose Smut (Kaanji)",
    symptoms: "Bali kaali powder mein badal jati hai",
    pesticide: "Beej ka treatment: Carboxin ya Vitavax",
    dosageNote: "Bounai se pehle beej treat karein — spray se ilaj nahi hota",
  ),
  PestInfo(
    name: "Sufaid Phaphoondi (Powdery Mildew)",
    symptoms: "Pattoon par safaid powder jaisi tehni",
    pesticide: "Sulphur 80% WDG",
    dosageNote: "2.5 g per litre pani",
  ),
  PestInfo(
    name: "Chappa (Aphids)",
    symptoms: "Chhote sabz/kaale keeray pattoon aur tanay par jamaa",
    pesticide: "Imidacloprid 200SL (jese Confidor)",
    dosageNote: "0.5 ml per litre pani",
  ),
  PestInfo(
    name: "Fauji Kira (Armyworm)",
    symptoms: "Raat ko pattay chaba jate hain, din mein chupay rehte hain",
    pesticide: "Chlorpyrifos 40% EC ya Emamectin Benzoate",
    dosageNote: "2 ml per litre pani, shaam ke waqt spray karein",
  ),
  PestInfo(
    name: "Deemak (Termite)",
    symptoms: "Jarhein khokhli ho jati hain, paudha muraza ho jata hai",
    pesticide: "Chlorpyrifos 40% EC — zameen mein mix karein",
    dosageNote: "Bounai se pehle zameen treatment behtar hai",
  ),
  PestInfo(
    name: "Dhaani Ghaas (Phalaris Minor - Weed)",
    symptoms: "Gandum jaisi ghaas jo paidawar kam kar deti hai",
    pesticide: "Isoproturon ya Pendimethalin (weedicide)",
    dosageNote: "Bounai ke foran baad ya ugne ke 30-35 din baad, label ke mutabiq",
  ),
  PestInfo(
    name: "Chuhay (Rat Damage)",
    symptoms: "Bali aur danay khaa liye jate hain",
    pesticide: "Zinc Phosphide bait (zeher-khez chara)",
    dosageNote: "Bilon ke qareeb rakhein, bachon/janwaron se door",
  ),
];

const _riceIssues = [
  PestInfo(
    name: "Tana Chedak (Stem Borer)",
    symptoms: "Beech ka patta sookh jata hai (dead heart)",
    pesticide: "Cartap Hydrochloride (jese Padan)",
    dosageNote: "Granules zameen mein ya spray, label ke mutabiq",
  ),
  PestInfo(
    name: "Blast Disease",
    symptoms: "Pattoon par ankh numa (spindle-shaped) dhabbe",
    pesticide: "Tricyclazole (jese Beam)",
    dosageNote: "0.6 g per litre pani",
  ),
  PestInfo(
    name: "Chitti Sundhi (Brown Plant Hopper)",
    symptoms: "Paudhe achanak jhulas kar sookh jate hain (hopper burn)",
    pesticide: "Imidacloprid 200SL",
    dosageNote: "0.3-0.5 ml per litre pani",
  ),
  PestInfo(
    name: "Patta Lapetak (Leaf Folder)",
    symptoms: "Pattay lapet kar andar se khaye jate hain",
    pesticide: "Chlorantraniliprole 18.5% SC",
    dosageNote: "0.3 ml per litre pani",
  ),
  PestInfo(
    name: "Gundhi Bug",
    symptoms: "Danon se doodh chus lete hain, danay khaali reh jate hain",
    pesticide: "Malathion 57% EC",
    dosageNote: "2 ml per litre pani, subah/shaam spray karein",
  ),
  PestInfo(
    name: "Bacterial Leaf Blight",
    symptoms: "Pattoon ke kinaray se peela/sookha hona shuru hota hai",
    pesticide: "Copper Oxychloride",
    dosageNote: "2.5 g per litre pani",
  ),
  PestInfo(
    name: "Jhoothi Kaanji (False Smut)",
    symptoms: "Danay hare/kaale golay mein badal jate hain",
    pesticide: "Propiconazole (phool ki stage par preventive spray)",
    dosageNote: "1 ml per litre pani",
  ),
  PestInfo(
    name: "Khoonti Kira (Rice Hispa)",
    symptoms: "Pattoon par safed lakeerein (mining damage)",
    pesticide: "Chlorpyrifos 40% EC",
    dosageNote: "2 ml per litre pani",
  ),
];

const _cottonIssues = [
  PestInfo(
    name: "Safaid Makhi (Whitefly)",
    symptoms: "Chhoti safaid makhiyan patton ke neechay",
    pesticide: "Imidacloprid ya Acetamiprid",
    dosageNote: "Label ke mutabiq, subah/shaam spray karein",
  ),
  PestInfo(
    name: "Sundhi (American Bollworm)",
    symptoms: "Tinday mein chhed, andar sundhi",
    pesticide: "Emamectin Benzoate 1.9% EC",
    dosageNote: "0.5 ml per litre pani",
  ),
  PestInfo(
    name: "Gulabi Sundhi (Pink Bollworm)",
    symptoms: "Tinday andar se kharab, rosette/gulabi larvae",
    pesticide: "Chlorantraniliprole 18.5% SC",
    dosageNote: "0.3 ml per litre pani",
  ),
  PestInfo(
    name: "CLCV (Cotton Leaf Curl Virus)",
    symptoms: "Pattay mudh jate hain aur mota ho jate hain",
    pesticide: "Koi seedha ilaj nahi — Whitefly (vector) control karein: Imidacloprid",
    dosageNote: "Mutasira paudhe hata dein, resistant beej agli dafa use karein",
  ),
  PestInfo(
    name: "Til Kira (Jassid)",
    symptoms: "Pattay kinaron se peele ho kar mudhna shuru hote hain",
    pesticide: "Acetamiprid 20% SP",
    dosageNote: "0.4 g per litre pani",
  ),
  PestInfo(
    name: "Mealybug",
    symptoms: "Safaid rooi jaisa jama tanon aur pattoon par",
    pesticide: "Profenofos 40% + Cypermethrin 4% EC",
    dosageNote: "2 ml per litre pani",
  ),
  PestInfo(
    name: "Jarhon ka Saraan (Root Rot)",
    symptoms: "Paudha achanak murjha jata hai, jarhein kaali",
    pesticide: "Carbendazim zameen mein drench karein",
    dosageNote: "2 g per litre pani, jarhon ke qareeb dalein",
  ),
  PestInfo(
    name: "Thrips",
    symptoms: "Pattay upar ki taraf mudh jate hain, chandi jaisi chamak",
    pesticide: "Spinosad 45% SC",
    dosageNote: "0.3 ml per litre pani",
  ),
];

const _sugarcaneIssues = [
  PestInfo(
    name: "Laal Saraan (Red Rot)",
    symptoms: "Tanay ke andar surkh rang, khushbu badal jati hai",
    pesticide: "Carbendazim 50% WP (beej ka treatment behtar hai)",
    dosageNote: "Mutasira paudhe jala dein, resistant qisam lagayen",
  ),
  PestInfo(
    name: "Top Borer",
    symptoms: "Upar ka hissa sookh jata hai",
    pesticide: "Chlorantraniliprole 18.5% SC",
    dosageNote: "0.3 ml per litre pani",
  ),
  PestInfo(
    name: "Root Borer",
    symptoms: "Jarhon ke qareeb tana khokhla, paudha girta hai",
    pesticide: "Chlorpyrifos 40% EC zameen mein",
    dosageNote: "2 ml per litre pani, jarhon ke qareeb",
  ),
  PestInfo(
    name: "Pyrilla (Leaf Hopper)",
    symptoms: "Pattay peele ho kar sookhna, shakar jaisi chipchipi tehen",
    pesticide: "Imidacloprid 200SL",
    dosageNote: "0.4 ml per litre pani",
  ),
  PestInfo(
    name: "Ooni Chappa (Woolly Aphid)",
    symptoms: "Safaid rooi jaisa jama pattoon ke neechay",
    pesticide: "Imidacloprid ya Thiamethoxam",
    dosageNote: "0.3 ml per litre pani",
  ),
  PestInfo(
    name: "Kaanji (Smut)",
    symptoms: "Upar se lambi kaali chabuk jaisi shakal",
    pesticide: "Mutasira paudhe ukhaar kar jalayen, resistant qisam lagayen",
    dosageNote: "Koi spray asar nahi karta — rokthaam hi ilaj hai",
  ),
  PestInfo(
    name: "Deemak (Termite)",
    symptoms: "Jarhein aur nichla tana khokhla",
    pesticide: "Chlorpyrifos 40% EC",
    dosageNote: "Zameen treatment, bounai se pehle",
  ),
];

const _maizeIssues = [
  PestInfo(
    name: "Fall Armyworm",
    symptoms: "Pattoon mein gol chhed, beech ke patton mein bit (droppings)",
    pesticide: "Emamectin Benzoate ya Chlorantraniliprole",
    dosageNote: "0.4 ml per litre pani, whorl (beech) mein spray karein",
  ),
  PestInfo(
    name: "Tana Chedak (Stem Borer)",
    symptoms: "Tanay mein chhed, paudha kamzor",
    pesticide: "Carbofuran 3G granules",
    dosageNote: "Whorl mein daalein",
  ),
  PestInfo(
    name: "Maize Rust",
    symptoms: "Pattoon par surkhi mael dhabbe",
    pesticide: "Mancozeb 80% WP",
    dosageNote: "2.5 g per litre pani",
  ),
  PestInfo(
    name: "Katra Kira (Cutworm)",
    symptoms: "Chhote paudhe zameen ke qareeb se kat kar gir jate hain",
    pesticide: "Chlorpyrifos 40% EC zameen mein spray",
    dosageNote: "2 ml per litre pani, shaam ke waqt",
  ),
  PestInfo(
    name: "Downy Mildew",
    symptoms: "Pattoon par safaid/zard lakeerein, paudha kamzor",
    pesticide: "Metalaxyl + Mancozeb",
    dosageNote: "2.5 g per litre pani",
  ),
  PestInfo(
    name: "Patta Jhulsa (Leaf Blight)",
    symptoms: "Lambay bhoore dhabbe pattoon par",
    pesticide: "Mancozeb 80% WP",
    dosageNote: "2.5 g per litre pani",
  ),
];

const _vegetableIssues = [
  PestInfo(
    name: "Chappa (Aphids)",
    symptoms: "Chhote keeray pattoon par jamaa, patay mudh jate hain",
    pesticide: "Imidacloprid 200SL",
    dosageNote: "0.5 ml per litre pani",
  ),
  PestInfo(
    name: "Safaid Makhi (Whitefly)",
    symptoms: "Patton ke neechay chhoti safaid makhiyan",
    pesticide: "Acetamiprid 20% SP",
    dosageNote: "0.4 g per litre pani",
  ),
  PestInfo(
    name: "Ful/Phal ki Sundhi (Fruit Borer)",
    symptoms: "Phal mein chhed",
    pesticide: "Emamectin Benzoate",
    dosageNote: "0.5 ml per litre pani",
  ),
  PestInfo(
    name: "Sufaid Phaphoondi (Powdery Mildew)",
    symptoms: "Pattoon par safaid powder jaisi tehni",
    pesticide: "Sulphur 80% WDG ya Karathane",
    dosageNote: "2-3 g per litre pani",
  ),
  PestInfo(
    name: "Early Blight",
    symptoms: "Pattoon par gol halqoon wale bhoore dhabbe (jese tamatar/aloo)",
    pesticide: "Mancozeb 80% WP",
    dosageNote: "2.5 g per litre pani, har 10 din baad",
  ),
  PestInfo(
    name: "Late Blight",
    symptoms: "Pattoon aur phal par paani jaisa sayah dhabba, tezi se phailta hai",
    pesticide: "Metalaxyl + Mancozeb",
    dosageNote: "2.5 g per litre pani, barish se pehle preventive spray karein",
  ),
  PestInfo(
    name: "Damping Off (Naye Paudhon ka Girna)",
    symptoms: "Nursery ke chhote paudhe zameen ke paas se gal kar gir jate hain",
    pesticide: "Beej ko Thiram se treat karein, zameen mein Carbendazim",
    dosageNote: "Nursery banane se pehle beej treatment karein",
  ),
  PestInfo(
    name: "Root Knot Nematode",
    symptoms: "Jarhon par ganthein/gilti, paudha kamzor",
    pesticide: "Carbofuran 3G zameen mein",
    dosageNote: "Paudhon ki bounai se pehle zameen treatment",
  ),
  PestInfo(
    name: "Thrips",
    symptoms: "Pattay/phool chandi jaisi chamak ke sath mudhna",
    pesticide: "Spinosad 45% SC",
    dosageNote: "0.3 ml per litre pani",
  ),
];

List<PestInfo> pestIssuesFor(String cropName) {
  final name = cropName.toLowerCase();
  if (name.contains('gandum') || name.contains('wheat')) return _wheatIssues;
  if (name.contains('chawal') || name.contains('rice')) return _riceIssues;
  if (name.contains('kapas') || name.contains('cotton')) return _cottonIssues;
  if (name.contains('ganna') || name.contains('sugarcane')) return _sugarcaneIssues;
  if (name.contains('makai') || name.contains('maize')) return _maizeIssues;
  return _vegetableIssues;
}