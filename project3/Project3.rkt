#lang typed/racket

(require "../include/cs151-core.rkt")
(require "../include/cs151-image.rkt")
(require "../include/cs151-universe.rkt")
(require typed/test-engine/racket-tests)

(define-struct (Some T)
  ([value : T]))

(define-type (Optional T)
  (U 'None (Some T)))

(define-type TickInterval
  Positive-Exact-Rational)

(define-struct Date
  ([month : Integer]
   [day : Integer]
   [year : Integer]))

(define-type Stroke
  (U 'Freestyle 'Backstroke 'Breaststroke 'Butterfly))

(define-struct Event
  ([gender : (U 'Men 'Women)]
   [race-distance : Integer]
   [stroke : Stroke]
   [name : String]
   [date : Date]))

(define-type Country
  (U 'AFG 'ALB 'ALG 'AND 'ANG 'ANT 'ARG 'ARM 'ARU 'ASA 'AUS 'AUT 'AZE 'BAH
     'BAN 'BAR 'BDI 'BEL 'BEN 'BER 'BHU 'BIH 'BIZ 'BLR 'BOL 'BOT 'BRA 'BRN
     'BRU 'BUL 'BUR 'CAF 'CAM 'CAN 'CAY 'CGO 'CHA 'CHI 'CHN 'CIV 'CMR 'COD
     'COK 'COL 'COM 'CPV 'CRC 'CRO 'CUB 'CYP 'CZE 'DEN 'DJI 'DMA 'DOM 'ECU
     'EGY 'ERI 'ESA 'ESP 'EST 'ETH 'FIJ 'FIN 'FRA 'FSM 'GAB 'GAM 'GBR 'GBS
     'GEO 'GEQ 'GER 'GHA 'GRE 'GRN 'GUA 'GUI 'GUM 'GUY 'HAI 'HON 'HUN 'INA
     'IND 'IRI 'IRL 'IRQ 'ISL 'ISR 'ISV 'ITA 'IVB 'JAM 'JOR 'JPN 'KAZ 'KEN
     'KGZ 'KIR 'KOR 'KOS 'KSA 'KUW 'LAO 'LAT 'LBA 'LBN 'LBR 'LCA 'LES 'LIE
     'LTU 'LUX 'MAD 'MAR 'MAS 'MAW 'MDA 'MDV 'MEX 'MGL 'MHL 'MKD 'MLI 'MLT
     'MNE 'MON 'MOZ 'MRI 'MTN 'MYA 'NAM 'NCA 'NED 'NEP 'NGR 'NIG 'NOR 'NRU
     'NZL 'OMA 'PAK 'PAN 'PAR 'PER 'PHI 'PLE 'PLW 'PNG 'POL 'POR 'PRK 'QAT
     'ROU 'RSA 'ROC 'RUS 'RWA 'SAM 'SEN 'SEY 'SGP 'SKN 'SLE 'SLO 'SMR 'SOL
     'SOM 'SRB 'SRI 'SSD 'STP 'SUD 'SUI 'SUR 'SVK 'SWE 'SWZ 'SYR 'TAN 'TGA
     'THA 'TJK 'TKM 'TLS 'TOG 'TTO 'TUN 'TUR 'TUV 'UAE 'UGA 'UKR 'URU 'USA
     'UZB 'VAN 'VEN 'VIE 'VIN 'YEM 'ZAM 'ZIM))

(define-struct IOC
  ([abbrev : Country]
   [country : String]))

(define-struct Swimmer
  ([lname : String]
   [fname : String]
   [country : Country]
   [height : Real]))

(define-struct Result
  ([swimmer : Swimmer]
   [splits : (Listof Real)]))

(define-type Mode
  (U 'choose 'running 'paused 'done))

(define-struct Sim
  ([mode : Mode]
   [event : Event]
   [tick-rate : TickInterval]
   [sim-speed : (U '1x '2x '4x '8x)]
   [sim-clock : Real]
   [pixels-per-meter : Integer]
   [pool : (Listof Result)] ;; in lane order
   [labels : Image] ;; corresponding to lane order
   [ranks : (Listof Integer)] ;; in lane order
   [end-time : Real]
   [file-chooser : (Optional FileChooser)]))

(define-struct Position
  ([x-position : Real]
   [direction : (U 'east 'west 'finished)]))

(: ioc-abbrevs (Listof IOC))
(define ioc-abbrevs
  (list (IOC 'AFG "Afghanistan")
        (IOC 'ALB "Albania")
        (IOC 'ALG "Algeria")
        (IOC 'AND "Andorra")
        (IOC 'ANG "Angola")
        (IOC 'ANT "Antigua Barbuda")
        (IOC 'ARG "Argentina")
        (IOC 'ARM "Armenia")
        (IOC 'ARU "Aruba")
        (IOC 'ASA "American Samoa")
        (IOC 'AUS "Australia")
        (IOC 'AUT "Austria")
        (IOC 'AZE "Azerbaijan")
        (IOC 'BAH "Bahamas")
        (IOC 'BAN "Bangladesh")
        (IOC 'BAR "Barbados")
        (IOC 'BDI "Burundi")
        (IOC 'BEL "Belgium")
        (IOC 'BEN "Benin")
        (IOC 'BER "Bermuda")
        (IOC 'BHU "Bhutan")
        (IOC 'BIH "Bosnia Herzegovina")
        (IOC 'BIZ "Belize")
        (IOC 'BLR "Belarus")
        (IOC 'BOL "Bolivia")
        (IOC 'BOT "Botswana")
        (IOC 'BRA "Brazil")
        (IOC 'BRN "Bahrain")
        (IOC 'BRU "Brunei")
        (IOC 'BUL "Bulgaria")
        (IOC 'BUR "Burkina Faso")
        (IOC 'CAF "Central African Republic")
        (IOC 'CAM "Cambodia")
        (IOC 'CAN "Canada")
        (IOC 'CAY "Cayman Islands")
        (IOC 'CGO "Congo Brazzaville")
        (IOC 'CHA "Chad")
        (IOC 'CHI "Chile")
        (IOC 'CHN "China")
        (IOC 'CIV "Cote dIvoire")
        (IOC 'CMR "Cameroon")
        (IOC 'COD "Congo Kinshasa")
        (IOC 'COK "Cook Islands")
        (IOC 'COL "Colombia")
        (IOC 'COM "Comoros")
        (IOC 'CPV "Cape Verde")
        (IOC 'CRC "Costa Rica")
        (IOC 'CRO "Croatia")
        (IOC 'CUB "Cuba")
        (IOC 'CYP "Cyprus")
        (IOC 'CZE "Czechia")
        (IOC 'DEN "Denmark")
        (IOC 'DJI "Djibouti")
        (IOC 'DMA "Dominica")
        (IOC 'DOM "Dominican Republic")
        (IOC 'ECU "Ecuador")
        (IOC 'EGY "Egypt")
        (IOC 'ERI "Eritrea")
        (IOC 'ESA "El Salvador")
        (IOC 'ESP "Spain")
        (IOC 'EST "Estonia")
        (IOC 'ETH "Ethiopia")
        (IOC 'FIJ "Fiji")
        (IOC 'FIN "Finland")
        (IOC 'FRA "France")
        (IOC 'FSM "Micronesia")
        (IOC 'GAB "Gabon")
        (IOC 'GAM "Gambia")
        (IOC 'GBR "United Kingdom")
        (IOC 'GBS "Guinea-Bissau")
        (IOC 'GEO "Georgia")
        (IOC 'GEQ "Equatorial Guinea")
        (IOC 'GER "Germany")
        (IOC 'GHA "Ghana")
        (IOC 'GRE "Greece")
        (IOC 'GRN "Grenada")
        (IOC 'GUA "Guatemala")
        (IOC 'GUI "Guinea")
        (IOC 'GUM "Guam")
        (IOC 'GUY "Guyana")
        (IOC 'HAI "Haiti")
        (IOC 'HON "Honduras")
        (IOC 'HUN "Hungary")
        (IOC 'INA "Indonesia")
        (IOC 'IND "India")
        (IOC 'IRI "Iran")
        (IOC 'IRL "Ireland")
        (IOC 'IRQ "Iraq")
        (IOC 'ISL "Iceland")
        (IOC 'ISR "Israel")
        (IOC 'ISV "US Virgin Islands")
        (IOC 'ITA "Italy")
        (IOC 'IVB "British Virgin Islands")
        (IOC 'JAM "Jamaica")
        (IOC 'JOR "Jordan")
        (IOC 'JPN "Japan")
        (IOC 'KAZ "Kazakhstan")
        (IOC 'KEN "Kenya")
        (IOC 'KGZ "Kyrgyzstan")
        (IOC 'KIR "Kiribati")
        (IOC 'KOR "South Korea")
        (IOC 'KOS "Kosovo")
        (IOC 'KSA "Saudi Arabia")
        (IOC 'KUW "Kuwait")
        (IOC 'LAO "Laos")
        (IOC 'LAT "Latvia")
        (IOC 'LBA "Libya")
        (IOC 'LBN "Lebanon")
        (IOC 'LBR "Liberia")
        (IOC 'LCA "St Lucia")
        (IOC 'LES "Lesotho")
        (IOC 'LIE "Liechtenstein")
        (IOC 'LTU "Lithuania")
        (IOC 'LUX "Luxembourg")
        (IOC 'MAD "Madagascar")
        (IOC 'MAR "Morocco")
        (IOC 'MAS "Malaysia")
        (IOC 'MAW "Malawi")
        (IOC 'MDA "Moldova")
        (IOC 'MDV "Maldives")
        (IOC 'MEX "Mexico")
        (IOC 'MGL "Mongolia")
        (IOC 'MHL "Marshall Islands")
        (IOC 'MKD "North Macedonia")
        (IOC 'MLI "Mali")
        (IOC 'MLT "Malta")
        (IOC 'MNE "Montenegro")
        (IOC 'MON "Monaco")
        (IOC 'MOZ "Mozambique")
        (IOC 'MRI "Mauritius")
        (IOC 'MTN "Mauritania")
        (IOC 'MYA "Myanmar Burma")
        (IOC 'NAM "Namibia")
        (IOC 'NCA "Nicaragua")
        (IOC 'NED "Netherlands")
        (IOC 'NEP "Nepal")
        (IOC 'NGR "Nigeria")
        (IOC 'NIG "Niger")
        (IOC 'NOR "Norway")
        (IOC 'NRU "Nauru")
        (IOC 'NZL "New Zealand")
        (IOC 'OMA "Oman")
        (IOC 'PAK "Pakistan")
        (IOC 'PAN "Panama")
        (IOC 'PAR "Paraguay")
        (IOC 'PER "Peru")
        (IOC 'PHI "Philippines")
        (IOC 'PLE "Palestinian Territories")
        (IOC 'PLW "Palau")
        (IOC 'PNG "Papua New Guinea")
        (IOC 'POL "Poland")
        (IOC 'POR "Portugal")
        (IOC 'PRK "North Korea")
        (IOC 'QAT "Qatar")
        (IOC 'ROU "Romania")
        (IOC 'RSA "South Africa")
        (IOC 'ROC "Russia")
        (IOC 'RUS "Russia")
        (IOC 'RWA "Rwanda")
        (IOC 'SAM "Samoa")
        (IOC 'SEN "Senegal")
        (IOC 'SEY "Seychelles")
        (IOC 'SGP "Singapore")
        (IOC 'SKN "St Kitts Nevis")
        (IOC 'SLE "Sierra Leone")
        (IOC 'SLO "Slovenia")
        (IOC 'SMR "San Marino")
        (IOC 'SOL "Solomon Islands")
        (IOC 'SOM "Somalia")
        (IOC 'SRB "Serbia")
        (IOC 'SRI "Sri Lanka")
        (IOC 'SSD "South Sudan")
        (IOC 'STP "Sao Tome Principe")
        (IOC 'SUD "Sudan")
        (IOC 'SUI "Switzerland")
        (IOC 'SUR "Suriname")
        (IOC 'SVK "Slovakia")
        (IOC 'SWE "Sweden")
        (IOC 'SWZ "Eswatini")
        (IOC 'SYR "Syria")
        (IOC 'TAN "Tanzania")
        (IOC 'TGA "Tonga")
        (IOC 'THA "Thailand")
        (IOC 'TJK "Tajikistan")
        (IOC 'TKM "Turkmenistan")
        (IOC 'TLS "Timor Leste")
        (IOC 'TOG "Togo")
        (IOC 'TTO "Trinidad Tobago")
        (IOC 'TUN "Tunisia")
        (IOC 'TUR "Turkey")
        (IOC 'TUV "Tuvalu")
        (IOC 'UAE "United Arab Emirates")
        (IOC 'UGA "Uganda")
        (IOC 'UKR "Ukraine")
        (IOC 'URU "Uruguay")
        (IOC 'USA "United States")
        (IOC 'UZB "Uzbekistan")
        (IOC 'VAN "Vanuatu")
        (IOC 'VEN "Venezuela")
        (IOC 'VIE "Vietnam")
        (IOC 'VIN "St Vincent Grenadines")
        (IOC 'YEM "Yemen")
        (IOC 'ZAM "Zambia")
        (IOC 'ZIM "Zimbabwe")))

(define-struct (KeyValue K V)
  ([key : K]
   [value : V]))

(define-struct (Association K V)
  ([key=? : (K K -> Boolean)]
   [data : (Listof (KeyValue K V))]))

(define-struct FileChooser
  ([directory : String]
   [chooser : (Association Char String)]))
;; a map of chars #\a, #\b etc. to file names

(: find-assoc : All (K V) K (Association K V) -> (Optional V))
;; given a key and an association,
;; return the corresponding value, if there is one
(define (find-assoc k asso)
  (match asso
    [(Association key=? data)
     (match data
       ['() 'None]
       [(cons head tail) (if (key=? k (KeyValue-key head))
                             (Some (KeyValue-value head))
                             (find-assoc k (Association key=? tail)))])]))

(: split : Char String -> (Listof String))
;; split a string around the given character
;; ex: (split #\x "abxcdxyyz") -> (list "ab" "cd" "yyz")
;; ex: (split #\, "Chicago,IL,60637") -> (list "Chicago" "IL" "60637")
;; ex: (split #\: "abcd") -> (list "abcd")
(define (split char str)
  (local
    {(: indexer (-> Char String Integer Integer))
     ;; returns the index of char in the string
     (define (indexer char str ind)
       (if (> ind (sub1 (string-length str)))
           (sub1 ind)
           (if (char=? char (string-ref str ind))
               ind
               (indexer char str (add1 ind)))))}
    (match (string->list str)
      ['() '()]
      [_ (append (list
                  (if (= (string-length str) (add1 (indexer char str 0)))
                      (substring str
                                 0
                                 (add1 (indexer char str 0)))
                      (substring str
                                 0
                                 (indexer char str 0))))
                 (split char (substring str 
                                        (add1 (indexer char str 0)))))])))

(: b-semi (-> String String))
;; returns string before the semi colon
(define (b-semi str)
  (match (index-of (string->list str) #\:)
    [#f ""]
    [_ 
     (substring str 0 (assert (index-of (string->list str) #\:)))]))

(: a-semi (-> String String))
;; returns string after the semi colon
(define (a-semi str)
  (match (index-of (string->list str) #\:)
    [#f ""]
    [_      
     (substring str (add1 (assert (index-of (string->list str) #\:))))]))

(: event (-> (Listof String) String))
;; returns the Event name
(define (event swm)
  (match swm
    [(cons head tail)
     (match (b-semi head)
       ["event"
        (a-semi head)]
       [_
        (event tail)])]))

(: gender (-> (Listof String) String))
;; returns gender for event
(define (gender swm)
  (match swm
    [(cons head tail)
     (match (b-semi head)
       ["gender"
        (a-semi head)]
       [_
        (gender tail)])]))

(: dist (-> (Listof String) Integer))
;; returns distance of event
(define (dist swm)
  (match swm
    [(cons head tail)
     (match (b-semi head)
       ["distance"
        (cast (string->number (a-semi head)) Integer)]
       [_
        (dist tail)])]))
     
(: stroke (-> (Listof String) String))
;; returns stroke swum during event
(define (stroke swm)
  (match swm
    [(cons head tail)
     (match (b-semi head)
       ["stroke"
        (a-semi head)]
       [_
        (stroke tail)])]))

(: date (-> (Listof String) Date))
;; returns date of event
(define (date swm)
  (match swm
    [(cons head tail)
     (match (b-semi head)
       ["date"
        (local
          {(define dates (split #\|
                                (a-semi head)))}
          (Date (cast (string->number
                       (list-ref dates 1))
                      Integer)
                (cast (string->number
                       (list-ref dates 0))
                      Integer)    
                (cast (string->number
                       (list-ref dates 2))
                      Integer)))]
       [_
        (date tail)])]))

(: order (-> (Listof String) (Listof String)))
;; orders results in lane order
(define (order swm)
  (local
    {(: add (-> (Listof String) (Listof String)))
     ;; if starting in result, adds the remaining information
     ;; after the semi colon 
     (define (add swm)
       (match swm
         ['() '()]
         [(cons head tail)
          (match (b-semi head)
            ["result"
             (append (list (a-semi head)) (add tail))]
            [_
             (add tail)])]))}
    (sort (add swm) string<?)))
                  
                  
(: swimmer (-> String Swimmer))
;; creates swimmer from string containg lname fnam country etc. 
(define (swimmer swm)       
  (local
    {(define else (split #\| swm))}
    (Swimmer (list-ref else 1)
             (list-ref else 2)
             (cast (string->symbol (list-ref else 3)) Country)
             (cast (string->number (list-ref else 4)) Real))))

(: splits (-> String (Listof Real)))
;; returns list of splits for given line 
(define (splits swm)
  (local
    {(: str-real (-> (Listof String) (Listof Real)))
     ;; turns list of strings to list of reals
     (define (str-real swm)
       (match swm
         ['() '()]
         [(cons head tail)
          (append (list (cast (string->number head) Real))
                  (str-real tail))]))}
    (str-real (split #\, (list-ref (split #\| swm) 5)))))

(: pools (-> (Listof String) (Listof Result)))
;; returns list pool for given file
(define (pools swm)
  (match swm
    ['() '()]
    [(cons head tail)
     (append (list (Result (swimmer head)
                           (splits head)))
             (pools tail))]))

(: sim-from-file : TickInterval Integer String -> Sim)
;; given a tick interval, a pixels-per-meter, and the name of an swm file,
;; build a Sim that contains the data from the file
;; - note: the Sim constructed by this function should contain 'None
;;         in the file-chooser slot
;; - note: GIGO applies to this function in all ways
(define (sim-from-file t ppm name)
  (local
    {(define samp (file->lines name))}
    
    (Sim 'running
         (Event (match (gender samp)
                  ["m" 'Men]
                  ["w" 'Women])
                (dist samp)
                (match (stroke samp)
                  ["Freestyle" 'Freestyle]
                  ["Backstroke" 'Backstroke]
                  ["Breaststroke" 'Breaststroke]
                  ["Butterfly" 'Butterfly])
                (event samp)
                (date samp))      
         t
         '1x
         0
         ppm
         (pools (order samp))
         (labels ppm (pools (order samp)))
         (map add1 (list-rank (length (pools (order samp)))
                              (pools (order samp))
                              (pools (order samp))))
         (slowest (pools (order samp)))
         'None)))


(: sim-from-file-fc (-> TickInterval Integer (Optional FileChooser) String Sim))
;; creates sim but also stores fc when program is not in directory
(define (sim-from-file-fc t ppm fc name)
  (local
    {(define samp (file->lines name))}    
    (match (sim-from-file t ppm name)
      [(Sim m e t ss sc ppm p l r et fch) (Sim m e t ss sc ppm p l r et fc)])))
  


(: iterate-flags (-> (Listof IOC) Country String))
;; returns string version of country
(define (iterate-flags iocs country)
  (match iocs
    [(cons h t) (if (symbol=? (IOC-abbrev h) country)
                    (IOC-country h)
                    (iterate-flags t country))]))

(: add-dashes (-> String String))
;; swaps spaces for dashes
(define (add-dashes str)
  (match (string->list str)
    ['() ""]
    [(cons head tail)
     (match head
       [#\space (string-append "-"
                               (add-dashes (list->string tail)))]
       [_ (string-append (list->string (list head))
                         (add-dashes (list->string tail)))])]))

(: flag-of : Country -> Image)
;; produce an image of a country's flag
;; - use bitmap/file and find the file include/flags
;; - it is OK to raise an error for a not-found file
(define (flag-of country)
  (match ioc-abbrevs
    [(cons h t)
     (bitmap/file (string-append "../include/flags/"
                                 (add-dashes
                                  (iterate-flags ioc-abbrevs country))
                                 ".png"))]))

(: labels (-> Integer (Listof Result) Image))
;; creates stack of flags corresponding to lane order
(define (labels ppm p)
  (match p
    ['() empty-image]
    [(cons head tail)
     (match head
       [(Result swimmer splits)
        (match swimmer
          [(Swimmer last first c height)
           (above (scale (/ (* ppm 2.5) (image-width (flag-of c)))
                         (flag-of c))
                  (labels ppm tail))])])]))

(: total (-> Result Real))
;; sums splits of a result
(define (total res)
  (match res
    [(Result swimmer splits)
     (match splits
       ['() 0]
       [(cons head tail) (+ head
                            (total (Result swimmer tail)))])]))

(: rank (-> Integer Result (Listof Result) Integer))
;; produces rank for swimer
(define (rank r res p)
  (match p
    ['() r]
    [(cons head tail)
     (cond
       [(<= (total res) (total head)) (rank (sub1 r) res tail)]
       [else (rank r res tail)])]))

(: list-rank (-> Integer (Listof Result) (Listof Result) (Listof Integer)))
;; ranks the swimmers in order of fastest to slowest
(define (list-rank swimmers pool p)
  (match p
    ['() '()]
    [(cons res tail)
     (append (list (rank swimmers res pool))
             (list-rank swimmers pool tail))]))

(: slowest (-> (Listof Result) Real))
;; returns the slowest swimmer time
(define (slowest pool)
  (match pool
    ['() 0]
    [(cons head tail)
     (if (> (total head)
            (slowest tail))
         (total head)
         (slowest tail))]))


(: build-file-chooser : String String -> FileChooser)
;; given a suffix and a directory name, build a file chooser
;; associating the characters a, b, c, etc. with all the files
;; in the given directory that have the given suffix
;; - note: you don't need to support more than 26 files
;;         (which would exhaust the alphabet) -- consider that
;;         GIGO if it happens
(define (build-file-chooser suff dir)
  (local
    {(define files (map path->string (directory-list dir)))    
     (: corfiles (-> (Listof String) (Listof String)))
     ;; adds files with suffix to list
     (define (corfiles f)
       (match f
         ['() '()]
         [(cons head tail)
          (if (string=? (substring head
                                   (- (string-length head)
                                      (string-length suff)))
                        suff)
              (append (list head) (corfiles tail))
              (corfiles tail))]))
     
     (define cfiles (corfiles files))
            
     (define alph (build-list (length cfiles) (lambda ([x : Integer])
                                                (integer->char (+ x 97)))))
     
     (: kv (-> Integer (KeyValue Char String)))
     ;; returns key value at given index of list
     (define (kv ind)
       (KeyValue (list-ref alph ind)
                 (list-ref cfiles ind)))
     
     (: listkv (-> Integer (Listof (KeyValue Char String))))
     ;; creates a list of keyvalue
     (define (listkv ind)
       (if (< ind (length alph))
           (append (list (kv ind))
                   (listkv (add1 ind)))
           '()))} 
    (FileChooser dir
                 (Association char=?
                              (listkv 0)))))

(: initial-sim : Event TickInterval Integer (Listof Result) -> Sim)
;; the parameters are an event, a tick interval, pixels per meter,
;; and a list of results corresponding to a race
;; - this function must precompute the labels, ranks, and end-time
;;   values based on the list of results
(define (initial-sim e t ppm p)
  (Sim 'choose
       e
       t
       '1x
       0
       ppm
       p
       empty-image
       '()
       0
       'None))

(: set-mode : Mode Sim -> Sim)
;; set the mode in simulation
(define (set-mode mode sim)
  (match sim
    [(Sim m e t ss sc ppm p l r et fc) (Sim mode e t ss sc ppm p l r et fc)]))

(: set-speed : (U '1x '2x '4x '8x) Sim -> Sim)
;; set the simulation speed
(define (set-speed sp sim)
  (match sim
    [(Sim m e t ss sc ppm p l r et fc) (Sim m e t sp sc ppm p l r et fc)]))

(: toggle-paused : Sim -> Sim)
;; set 'running sim to 'paused, and set 'paused sim to 'running
;; return 'done sim as is
(define (toggle-paused sim)
  (match sim
    [(Sim m e t ss sc ppm p l r et fc)
     (match m
       ['running (Sim 'paused e t ss sc ppm p l r et fc)]
       ['paused (Sim 'running e t ss sc ppm p l r et fc)]
       [_ (Sim m e t ss sc ppm p l r et fc)])]))

(: reset : Sim -> Sim)
;; reset the simulation to the beginning of the race
(define (reset sim)
  (match sim
    [(Sim m e t ss sc ppm p l r et fc)
     (Sim 'running e t ss 0 ppm p l r et fc)]))

(: check-key (-> Char (Optional String)))
;; checks if key is assoicated with a file name
(define (check-key char)
  (find-assoc char
              (FileChooser-chooser
               (build-file-chooser ".swm" 
                                   "C:Users/Kyle/kylew/swms"))))


(: react-to-keyboard : Sim String -> Sim)
;; set sim-speed to 1x, 2x, or 4x on "1", "2", "4"
;; reset the simulation on "r"
(define (react-to-keyboard sim key)
  (match sim
    [(Sim m e t ss sc ppm p l r et fc)
     (match m
       ['choose
        (match (cast (list-ref (string->list key) 0) Char)
          [x
           (match (find-assoc x
                              (FileChooser-chooser
                               (match fc
                                 [(Some t) t])))
             ['None sim]             
             [y (sim-from-file-fc
                 t
                 ppm
                 fc
                 (string-append (FileChooser-directory
                                 (match fc
                                   [(Some t) t]))
                                "/"
                                (match y
                                  [(Some y)  y])))])])]
       [_ 
        (match key
          ["1" (set-speed '1x sim)]
          ["2" (set-speed '2x sim)]
          ["4" (set-speed '4x sim)]
          ["8" (set-speed '8x sim)]
          ["r" (reset sim)]
          ["d" (Sim 'choose
                    (Event 'Men
                           0
                           'Freestyle
                           ""
                           (Date 0 0 0))
                    t
                    '1x
                    0
                    ppm
                    '()
                    empty-image
                    '()
                    0
                    fc)]
          [_ sim])])]))

(: react-to-mouse : Sim Integer Integer Mouse-Event -> Sim)
;; pause/unpause the simulation on "button-down"
(define (react-to-mouse sim x y event)
  (match sim
    [(Sim m e t ss sc ppm p l r et fc)
     (match m
       ['choose sim]
       [_ (match event
            ["button-down" (toggle-paused sim)]
            [_ sim])])]))

(: position : Real Result -> Real)
;; returns position of swimmer
(define (position ct res)
  (match res
    [(Result s splits)
     (match splits
       ['() 0]
       [(cons h t) (if (> ct h)
                       (+ 50 (position (- ct h) (Result s t)))
                       (+ (* (/ (- 50
                                   (Swimmer-height s))
                                h)
                             ct)
                          (/ (Swimmer-height s) 2)))])]))

(: current-position : Real Result -> Position)
;; the arguments to current-position are the current time and a result

;; - compute the given swimmer's current position, which
;;   includes a heading 'east or 'west, or 'finished
(define (current-position ct res)
  (match res
    [(Result s splits)
     (match splits
       [(cons h t) (Position (position ct res)
                             (if (= 1 (length (Result-splits res)))
                                 (if (even? (exact-floor
                                             (/ (position ct res) 50)))
                                     'east
                                     'west)
                                 (if (odd? (exact-floor
                                            (/ (position ct res) 50)))
                                     'east
                                     'west)))])]))

(: all-done (-> Sim Boolean))
;; checks if all swimmers are done
(define (all-done sim)
  (match sim
    [(Sim m e t ss sc ppm p l r et fc)
     (match p
       ['() #t]
       [(cons head tail) (and (>= (+ (Position-x-position
                                      (current-position sc head))
                                     (/ (Swimmer-height (Result-swimmer head))
                                        2))
                                  (* (length (Result-splits head)) 50))
                              (all-done
                               (Sim m e t ss sc ppm tail l r et fc)))])]))

(: react-to-tick : Sim -> Sim)
;; if simulation is 'running, increase sim-clock accordingly
;; - note: the amount of time added to sim-clock
;; depends on sim-speed and tick-rate
(define (react-to-tick sim)
  (match sim
    [(Sim m e t ss sc ppm p l r et fc)
     (match m
       ['choose sim]
       [_ 
        (if (all-done sim)
            (Sim 'done e t ss (slowest p) ppm p l r et fc)
            (match m
              ['running (match ss
                          ['1x (Sim m e t ss (+ sc (exact->inexact t))
                                    ppm p l r et fc)]
                          ['2x (Sim m e t ss
                                    (+ sc (* 2 (exact->inexact t)))
                                    ppm p l r et fc)]
                          ['4x (Sim m e t ss
                                    (+ sc (* 4 (exact->inexact t)))
                                    ppm p l r et fc)]
                          ['8x (Sim m e t ss
                                    (+ sc (* 8 (exact->inexact t)))
                                    ppm p l r et fc)])]
              [_ (Sim m e t ss sc ppm p l r et fc)]))])]))

(: mmsshh : Real -> String)
;; display an amount of time in MM:SS.HH format
;; where HH are hundredths of seconds
;; - don't worry about hours, since races are at most
;;   a few minutes long
;; - *do* append a trailing zero as needed
;; ex: (mmsshh 62.23) -> "1:02.23"
;; ex: (mmsshh 62.2)  -> "1:02.20"
(define (mmsshh sec)
  (local
    {(define min (exact-floor (/ sec 60)))
     (define secs (- sec (* min 60)))}
    (if (= min 0)
        (if (> secs 10)
            (real->decimal-string secs 2)
            (string-append "0"
                           (real->decimal-string secs 2)))
        (string-append (if (> min 10)
                           (number->string min)
                           (string-append "0"
                                          (number->string min)
                                          ":"))
                       (if (> secs 10)
                           (real->decimal-string secs 2)
                           (string-append "0"
                                          (real->decimal-string secs 2)))))))

(: done (-> Real Integer Result Boolean))
;; returns whether or not swimmer is finished
(define (done sc ppm res)
  (if (>= (+ (Position-x-position
              (current-position sc res))
             (/ (Swimmer-height (Result-swimmer res))
                2))
          (* (length (Result-splits res)) 50))
      #t
      #f))

(: draw-lane (-> Real Integer Result Integer
                 (Listof Result) Image))
;; draws swimmer in lane
(define (draw-lane sc ppm res swimmers p)
  (match (current-position sc res)
    [(Position pos dir)
     (if (done sc ppm res)
         (overlay (text (string-append "placed : "
                                       (number->string
                                        (add1 (rank swimmers res p)))
                                       "     With a time of "
                                       (mmsshh (total res)))
                        25
                        'black)                 
                  (rectangle (* 50 ppm)
                             (* 2.5 ppm)
                             'solid
                             'blue))
         (match dir
           ['east 
            (place-image (rotate 30
                                 (triangle (* (Swimmer-height
                                               (Result-swimmer res))
                                              ppm)
                                           'solid
                                           'lime))
                         (* (- pos
                               ( * 50 (exact-floor (/ pos
                                                      50))))
                            ppm)
                         (* 1.25 ppm)
                         (place-image (rectangle (* 50 ppm)
                                                 (* 2.5 ppm)
                                                 'solid
                                                 'blue)
                                      (* 25 ppm)
                                      (* 1.25 ppm) 
                                      (rectangle (* 50 ppm)
                                                 (* 2.5 ppm)
                                                 'solid
                                                 'white)))]
           ['west
            (place-image (rotate 210
                                 (triangle (* (Swimmer-height
                                               (Result-swimmer res))
                                              ppm)
                                           'solid
                                           'lime))
                         (* (- (- 50
                                  (/ (Swimmer-height (Result-swimmer res)) 2))
                               (- pos
                                  (* (exact-floor
                                      (/ pos 50)) 50)))
                            ppm)
                         (* 1.25 ppm)
                         (place-image (rectangle (* 50 ppm)
                                                 (* 2.5 ppm)
                                                 'solid
                                                 'blue)
                                      (* 25 ppm)
                                      (* 1.25 ppm) 
                                      (rectangle (* 50 ppm)
                                                 (* 2.5 ppm)
                                                 'solid
                                                 'white)))]))]))

(: draw-lanes (-> Sim (Listof Result) Integer Image))
;; draws lanes
(define (draw-lanes sim pool swimmers)
  (match sim
    [(Sim m e t ss sc ppm p l r et fc)
     (match p
       ['() empty-image]
       [(cons res tail)
        (above (draw-lane sc ppm res swimmers pool)
               (draw-lanes (Sim m e t ss sc ppm tail l r et fc)
                           pool
                           swimmers))])]))


(: draw-simulation : Sim -> Image)
;; draw the simulation in its current state,
;; including both graphical and textual elements
(define (draw-simulation sim)
  (match sim
    [(Sim m e t ss sc ppm p l r et fc)
     (match m
       ['choose
        (local
          {(: formatter (-> (Listof (KeyValue Char String)) (Listof String)))
           ;; formats associations
           (define (formatter chooser)
             (match chooser 
               ['()  '()]
               [(cons head tail)
                (append (list (string-append (string (KeyValue-key head))
                                             " : "
                                             (KeyValue-value head)))
                        (formatter tail))]))
           (: dirim (-> (Listof String) Image))
           ;; turns file directory into image
           (define (dirim d)
             (match d
               ['() empty-image]
               [(cons head tail)
                (above (overlay (text head 20 'black)
                                (rectangle 200
                                           100
                                           'solid
                                           'tan))
                       (dirim tail))]))}
          (overlay
           (above                               
            (text (string-append "Current directory is: "
                                 (FileChooser-directory
                                  (match fc
                                    [(Some t) t])))
                  20
                  'black)
            (dirim (formatter (Association-data
                               (FileChooser-chooser
                                (match fc
                                  [(Some t) t]))))))
           (rectangle 1500 1000 'solid 'white)))]
       [_ (above/align "left"
                       (place-image (rectangle (* 50 ppm)
                                               (* 2.5 ppm)
                                               'solid
                                               'blue)
                                    (* 25 ppm)
                                    (* 1.25 ppm) 
                                    (rectangle (* 50 ppm)
                                               (* 2.5 ppm)
                                               'solid
                                               'white))
                       (beside (draw-lanes sim p (length p))
                               l)
                       (place-image (rectangle (* 50 ppm)
                                               (* 2.5 ppm)
                                               'solid
                                               'blue)
                                    (* 25 ppm)
                                    (* 1.25 ppm) 
                                    (rectangle (* 50 ppm)
                                               (* 2.5 ppm)
                                               'solid
                                               'white))
                       (text (string-append
                              (Event-name e)
                              ": "
                              (match (Event-gender e)
                                ['Men "Men's "]
                                ['Women "Women's "])
                              (number->string (Event-race-distance e))
                              "m "
                              (match (Event-stroke e)
                                ['Freestyle "Freestyle "]
                                ['Backstroke "Backstroke "]
                                ['Breaststroke "Breaststroke "]
                                ['Butterfly "Butterfly "])
                              "("
                              (number->string (Date-day (Event-date e)))
                              " "
                              (number->string (Date-month (Event-date e)))
                              " "
                              (number->string (Date-year (Event-date e)))
                              ")")
                             20
                             'black)
                       (text (string-append "current rate is: "
                                            (match ss
                                              ['1x "1x"]
                                              ['2x "2x"]
                                              ['4x "4x"]
                                              ['8x "8x"]))
                             16
                             'black)
                       (text (string-append "simulated time(s): "
                                            (mmsshh sc))
                             16
                             'black))])]))

(: run : TickInterval Integer String -> Sim)
;; the run function should consume a tick interval, a pixels per meter,
;; and a path to a directory containing one or more .swm files
(define (run t ppm dir)
  (big-bang (Sim 'choose
                 (Event 'Men
                        0
                        'Freestyle
                        ""
                        (Date 0 0 0))
                 t
                 '1x
                 0
                 ppm
                 '()
                 empty-image
                 '()
                 0
                 (Some (build-file-chooser ".swm"
                                           dir))): Sim
    [on-key react-to-keyboard]
    [on-mouse react-to-mouse]
    [on-tick react-to-tick t]
    [to-draw draw-simulation]))

;; only one file shows up on the screen for some reason, w50.swm does not appear
;; cannot go back to directory from run screen, due to sim-from-file creating a
;; sim with 'None as a file chooser








                             

   




    

