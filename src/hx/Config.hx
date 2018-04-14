package;

/**
 * ...
 * @author Henri Sarasvirta
 */
@:expose("Config")
class Config
{

	public function new() 
	{
		
	}
	
	public static var ASSETS:Array<String> = [
		"img/black.png",
		"img/bg.jpg",
		"img/noise.jpg",
		
		"img/jars.json",
		"img/ui.json",
		
		"img/oxygen.json",
		"img/brohm.json",
		"img/lithium.json",
		"img/aluminium.json",
		"img/magnesium.json",
		
		"img/alu_bromide.json",
		"img/alu_oxide.json",
		"img/lithium_bromide.json",
		"img/lithium_oxide.json",
		"img/mag_bromide.json",
		"img/mag_oxide.json"
		
	];
	
	public static var VERSION:String  = "chemistry fall 0.1";
	
	
	public static var GRAVITY:Float = 0.1;

	public static var LANG:String = "en";
	
	public static function getText(key)
	{
		return Reflect.field(Reflect.field(TEXTS, LANG), key);
	}
	
	public static var TEXTS:Dynamic = { 
		'fi':
			{
				'help':'Muodosta 3 yhdistelmää\nioneista oikeilla varauksilla.\nVältä vääriä elementtejä.\n\nOhjaa kallistamalla puhelinta.\nPoista suolakiteet klikkaamalla.\n\nKemia\n    Anni Kukko\nGrafiikat\n    Laura K. Horton\nMusiikki\n    Lauri Leskinen\nKoodi+Ääniefektit\n    Henri Sarasvirta\n\n        EduGameJam 2018',
				
				'ions_not_equilibrium': 'Ionien määrä ei\nole tasapainossa',
				'extra_material':'Ylimääräistä materiaalia\nhavaittu',
				'perfect':'Tasapaino saavutettu!',
				
				'lithium_oxide':'Litiumoksidi on epäorgaaninen valkea suola,\njota käytetään lasitteiden ja\nemalien valmistuksessa.',
				'mag_oxide':'Magnesiumoksidi on valkoinen\nhygroskooppinen suola, jota\nesiintyy luonnossa periklaasi-mineraalina.',
				'alu_bromide':'Alumiinibromidi on väritön suola.\nSitä käytetään katalyyttinä joissakin\norgaanisen kemian reaktioissa.',
				'mag_bromide':'Magnesiumbromidi on hygroskooppinen\nsuola, jota käytetään joissakin\nmiedosti rauhoittavissa lääkkeissä',
				'lithium_bromide':'litiumbromidi on erittäin\nhygroskooppinen suola, minkä\ntakia sitä käytetään mm.\nilmastointilaitteissa veden sitojana.',
				'alu_oxide':'alumiinioksidi on valkoinen\nsuola, jota esiintyy luonnossa\nkorundissa, rubiinissa ja safiirissa'
			},
		'en':
			{
				'help':'Form 3 compounds by collecting\nions. Make sure that you get\nthe charges correct!\nAvoid unneeded elements.\n\nControl by tilting phone in\nportrait mode.\nTap salts to destroy them.\n\nChemistry\n    Anni Kukko\nGraphics\n    Laura K. Horton\nMusic\n    Lauri Leskinen\nCode+sfx\n    Henri Sarasvirta\n\n       EduGameJam 2018',
				
				'ions_not_equilibrium': 'Ions not in\nequilibrium',
				'extra_material':'Extra material\ndetected',
				'perfect':'Perfect!',
				
				'lithium_oxide':'Lithium oxide or lithia is an\ninorganic chemical compound.\nIt is a white solid.',
				'mag_oxide':'Magnesium oxide, or magnesia,\nis a white hygroscopic solid mineral that\noccurs naturally as periclase\nand is a source of magnesium.',
				'alu_bromide':'Aluminium bromide is any chemical compound\nwith the empirical formula AlBr.\nAluminium tribromide is the most common\nform of aluminium bromide.',
				'mag_bromide':'Magnesium bromide is a chemical compound\nof magnesium and bromine that is\nwhite and deliquescent.\nIt is often used as a mild sedative and\nas an anticonvulsant for treatment\nof nervous disorders.',
				'lithium_bromide':'Lithium bromide is a chemical\ncompound of lithium and bromine.\nIts extreme hygroscopic character makes\nLiBr useful as a desiccant in\ncertain air conditioning systems.',
				'alu_oxide':'Aluminium oxide is a chemical\ncompound of aluminium and oxygen.\nIt is the most commonly occurring of\nseveral aluminium oxides'
				
			}
		
	};
}