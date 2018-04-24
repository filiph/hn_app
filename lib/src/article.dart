class Article {
  final String text;
  final String domain;
  final String by;
  final String age;
  final int score;
  final int commentsCount;

  const Article(
      {this.text,
      this.domain,
      this.by,
      this.age,
      this.score,
      this.commentsCount});
}

final articles = [
  new Article(
    text:
        "Circular Shock Acoustic Waves in Ionosphere Triggered by Launch of Formosat‐5",
    domain: "wiley.com",
    by: "zdw",
    age: "3 hours",
    score: 177,
    commentsCount: 62,
  ),
  new Article(
    text: "BMW says electric car mass production not viable until 2020",
    domain: "reuters.com",
    by: "Mononokay",
    age: "2 hours",
    score: 81,
    commentsCount: 128,
  ),
  new Article(
    text: "Evolution Is the New Deep Learning",
    domain: "sentient.ai",
    by: "jonbaer",
    age: "4 hours",
    score: 200,
    commentsCount: 87,
  ),
  new Article(
    text: "TCP Tracepoints have arrived in Linux",
    domain: "brendangregg.com",
    by: "brendangregg",
    age: "1 hour",
    score: 35,
    commentsCount: 0,
  ),
  new Article(
    text:
        "Section 230: A Key Legal Shield for Facebook, Google Is About to Change",
    domain: "npr.org",
    by: "Mononokay",
    age: "5 hours",
    score: 156,
    commentsCount: 66,
  ),
  new Article(
    text: "A Visiting Star Jostled Our Solar System 70,000 Years Ago",
    domain: "gizmodo.com",
    by: "rbanffy",
    age: "7 hours",
    score: 175,
    commentsCount: 60,
  ),
  new Article(
    text: "Cow Game Extracted Facebook Data",
    domain: "theatlantic.com",
    by: "jameshart",
    age: "1 hour",
    score: 125,
    commentsCount: 56,
  ),
  new Article(
    text: "Ask HN: How do you find freelance work?",
    domain: "",
    by: "i_am_nobody",
    age: "2 hours",
    score: 82,
    commentsCount: 43,
  ),
  new Article(
    text:
        "Hedge-fund managers that do the most research will post the best returns",
    domain: "cnbc.com",
    by: "anonu",
    age: "6 hours",
    score: 149,
    commentsCount: 126,
  ),
  new Article(
    text:
        "Number systems of the world, sorted by complexity of counting (2006)",
    domain: "airnet.ne.jp",
    by: "ColinWright",
    age: "8 hours",
    score: 196,
    commentsCount: 90,
  ),
  new Article(
    text: "MIT’s new device can pull water from desert air",
    domain: "techcrunch.com",
    by: "evo_9",
    age: "43 minutes",
    score: 11,
    commentsCount: 11,
  ),
  new Article(
    text: "GitLab 10.6 released with CI/CD for GitHub",
    domain: "gitlab.com",
    by: "rbanffy",
    age: "4 hours",
    score: 177,
    commentsCount: 62,
  ),
  new Article(
    text: "Next-Gen Display: MicroLEDs",
    domain: "ieee.org",
    by: "rbanffy",
    age: "5 hours",
    score: 72,
    commentsCount: 39,
  ),
  new Article(
    text:
        "Power 9 May Dent X86 Servers: Alibaba, Google, Tencent Test IBM Systems",
    domain: "eetimes.com",
    by: "bcaulfield",
    age: "3 hours",
    score: 52,
    commentsCount: 50,
  ),
  new Article(
    text:
        "Show HN: Transfer files to mobile device by scanning a QR code from the terminal",
    domain: "github.com",
    by: "daw___",
    age: "7 hours",
    score: 143,
    commentsCount: 35,
  ),
  new Article(
    text: "Types of People Startups Should Hire, but Don’t",
    domain: "trifinlabs.com",
    by: "Shanerostad",
    age: "1 hour",
    score: 31,
    commentsCount: 27,
  ),
  new Article(
    text: "Steinhaus Longimeter",
    domain: "fairfield.edu",
    by: "ColinWright",
    age: "8 hours",
    score: 85,
    commentsCount: 16,
  ),
  new Article(
    text:
        "Data on 1.2M Facebook users from 2005 (2011) [use archive.org url in thread]",
    domain: "michaelzimmer.org",
    by: "feelin_googley",
    age: "1 hour",
    score: 72,
    commentsCount: 19,
  ),
  new Article(
    text: "The Myth of Authenticity Is Killing Tex-Mex",
    domain: "eater.com",
    by: "samclemens",
    age: "10 hours",
    score: 121,
    commentsCount: 128,
  ),
  new Article(
    text: "Show HN: Asynchronous HTTP/2 client for Python 2.7",
    domain: "github.com",
    by: "vsmhn",
    age: "8 hours",
    score: 75,
    commentsCount: 51,
  ),
  new Article(
    text: "Fractions in the Farey Sequences and the Stern-Brocot Tree",
    domain: "surrey.ac.uk",
    by: "fanf2",
    age: "6 hours",
    score: 45,
    commentsCount: 7,
  ),
  new Article(
    text: "Understanding CPU port contention",
    domain: "dendibakh.github.io",
    by: "matt_d",
    age: "10 hours",
    score: 96,
    commentsCount: 13,
  ),
  new Article(
    text:
        "Krita 4.0 – A painting app for cartoonists, illustrators, and concept artists",
    domain: "krita.org",
    by: "reddotX",
    age: "9 hours",
    score: 435,
    commentsCount: 125,
  ),
  new Article(
    text: "Cutting ‘Old Heads’ at IBM",
    domain: "propublica.org",
    by: "mwexler",
    age: "7 hours",
    score: 287,
    commentsCount: 240,
  ),
  new Article(
    text: "Where to Score: Classified Ads from Haight-Ashbury",
    domain: "theparisreview.org",
    by: "tintinnabula",
    age: "7 hours",
    score: 47,
    commentsCount: 12,
  ),
  new Article(
    text:
        "TravisBuddy: Adds comments to failed pull requests, tells author what went wrong",
    domain: "github.com",
    by: "bluzi",
    age: "8 hours",
    score: 37,
    commentsCount: 26,
  ),
  new Article(
    text: "Using Technical Debt in Your Favor",
    domain: "gitconnected.com",
    by: "treyhuffine",
    age: "7 hours",
    score: 140,
    commentsCount: 123,
  )
];
