import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssessmentHomePage extends StatefulWidget {
  const AssessmentHomePage({super.key});
  @override
  State<AssessmentHomePage> createState() => _AssessmentHomePageState();
}

class _AssessmentHomePageState extends State<AssessmentHomePage> {
  int currentSection = 0;
  int currentQuestion = 0;
  final List<int?> scores = List.filled(14, null);
  final Map<String, String> scoreCardMap = {};
  final List<TextEditingController> commentControllers = List.generate(
    9,
    (_) => TextEditingController(),
  );
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadSavedComments();
  }

  Future<void> _loadSavedComments() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 9; i++) {
      commentControllers[i].text = prefs.getString('comment_$i') ?? '';
    }
    setState(() {});
  }

  Future<void> _saveComments() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 9; i++) {
      await prefs.setString('comment_$i', commentControllers[i].text);
    }
  }

  final List<Map<String, dynamic>> sections = [
    // SECTION A
    {
      "title": "Knowledge & Experience",
      "subtitle": "Section A",
      "color": Colors.blue.shade700,
      "questions": [
        {
          "q": "1. Years of experience",
          "QuestionId": "5205497",

          "options": [
            {"text": "10+ years", "score": 5},
            {"text": "6–10 years", "score": 4},
            {"text": "3–5 years", "score": 3},
            {"text": "0–2 years", "score": 2},
            {"text": "< 1 year", "score": 0},
          ],
        },
        {
          "q": "2. Understanding of activity",
          "QuestionId": "5205501",

          "options": [
            {"text": "Excellent understanding", "score": 5},
            {"text": "Good understanding", "score": 4},
            {"text": "Average", "score": 3},
            {"text": "Poor", "score": 2},
            {"text": "Very poor", "score": 0},
          ],
        },
        {
          "q": "3. Loan purpose clarity",
          "QuestionId": "5205508",

          "options": [
            {"text": "Very clear", "score": 5},
            {"text": "Clear", "score": 4},
            {"text": "Somewhat clear", "score": 3},
            {"text": "Unclear", "score": 2},
            {"text": "Confusing", "score": 0},
          ],
        },
        {
          "q": "4. Risk awareness",
          "QuestionId": "5205512",

          "options": [
            {"text": "Strong risk awareness", "score": 5},
            {"text": "Good awareness", "score": 4},
            {"text": "Moderate", "score": 3},
            {"text": "Low", "score": 2},
            {"text": "No awareness", "score": 0},
          ],
        },
      ],
    },
    // SECTION B
    {
      "title": "Land & Farm Condition",
      "subtitle": "Section B",
      "color": Colors.green.shade700,
      "questions": [
        {
          "q": "5. Land & irrigation",
          "QuestionId": "5205537",

          "options": [
            {"text": "Good Reliable (Canal)", "score": 5},
            {"text": "Reliable (Drip/Borewell)", "score": 4},
            {"text": "Partially reliable", "score": 3},
            {"text": "Rainfed only", "score": 0},
          ],
        },
        {
          "q": "6. Crop/livestock condition",
          "QuestionId": "5205558",

          "options": [
            {"text": "Healthy", "score": 5},
            {"text": "Average", "score": 4},
            {"text": "Weak/Pest", "score": 2},
            {"text": "No Activity", "score": 0},
          ],
        },
        {
          "q": "7. Farm infrastructure",
          "QuestionId": "5205573",

          "options": [
            {"text": "Full Facilitated Excellent", "score": 5},
            {"text": "Good Facilitated", "score": 4},
            {"text": "Average Facilitated", "score": 3},
            {"text": "Poor Facilitated", "score": 2},
            {"text": "Not Facility", "score": 0},
          ],
        },
        {
          "q": "8. Yield / production",
          "QuestionId": "5205574",

          "options": [
            {"text": "Excellent", "score": 5},
            {"text": "Good", "score": 4},
            {"text": "Average", "score": 3},
            {"text": "Poor", "score": 2},
            {"text": "Not Facility", "score": 0},
          ],
        },
      ],
    },
    // SECTION C
    {
      "title": "Financial Stability",
      "subtitle": "Section C",
      "color": Colors.purple.shade700,
      "questions": [
        {
          "q": "9. Agri income stability",
          "QuestionId": "5205586",

          "options": [
            {
              "text":
                  "Income stable for the last 3 years (consistent yield + good marketability)",
              "score": 5,
            },
            {
              "text":
                  "Income stable for last 2 years (normal fluctuations only)",
              "score": 4,
            },
            {
              "text": "Income stable for 2 years BUT marketability is low",
              "score": 3,
            },
            {
              "text": "Income is low and unstable (seasonal/weather dependent)",
              "score": 2,
            },
            {
              "text":
                  "Crop yield low and marketability poor (high-risk income)",
              "score": 0,
            },
          ],
        },
        {
          "q": "10. Allied income",
          "QuestionId": "5205659",

          "options": [
            {
              "text": "Regular & stable for 3 years – strong support",
              "score": 5,
            },
            {
              "text": "Stable for last 2 years with predictable inflow",
              "score": 4,
            },
            {"text": "Exists but moderate/seasonal income", "score": 3},
            {"text": "Low due to poor productivity", "score": 2},
            {"text": "No allied income OR no marketability", "score": 0},
          ],
        },
        {
          "q": "11. Non-agri income",
          "QuestionId": "5205726",

          "options": [
            {
              "text": "Stable salary/business for 3+ years with proof",
              "score": 5,
            },
            {"text": "Stable for last 2 years", "score": 4},
            {"text": "Irregular or small-scale", "score": 3},
            {"text": "Low and unstable (daily wage)", "score": 2},
            {"text": "No non-agri income", "score": 0},
          ],
        },
        {
          "q": "12. Household expenses control",
          "QuestionId": "5205753",

          "options": [
            {"text": "Excellent control, regular savings", "score": 5},
            {"text": "Good control, some savings", "score": 4},
            {"text": "Average control, limited savings", "score": 3},
            {"text": "Poor control, frequent borrowing", "score": 2},
            {"text": "No control, chronic shortage", "score": 0},
          ],
        },
      ],
    },
    // SECTION D
    {
      "title": "Repayment Behaviour",
      "subtitle": "Section D",
      "color": Colors.orange.shade800,
      "questions": [
        {
          "q": "13. Existing liabilities Track record",
          "QuestionId": "5205793",

          "options": [
            {
              "text": "Excellent repayment; no overdue in last 24 months",
              "score": 5,
            },
            {"text": "Good; minor delays ≤30 days", "score": 4},
            {"text": "Average; 30–60 days delay observed", "score": 3},
            {"text": "Weak; multiple delays >60 days", "score": 2},
            {"text": "Poor; overdue >90 days or default", "score": 0},
          ],
        },
        {
          "q": "14. CIBIL score",
          "QuestionId": "5205827",

          "options": [
            {"text": "≥ 750 – Very low risk", "score": 5},
            {"text": "700–749 – Good", "score": 4},
            {"text": "650–699 – Average", "score": 3},
            {"text": "600–649 – Weak", "score": 2},
            {"text": "< 600 OR No hit – Very high risk", "score": 0},
          ],
        },
      ],
    },
    // SECTION E – COMMENTS
    {
      "title": "Comments & Observations",
      "subtitle": "Section E",
      "color": Colors.teal.shade700,
      "comments": [
        "The activities customer is involved in",
        "Details of Agriculture Activities",
        "Details of Allied/Investment/Development/Off-farm Activities",
        "Comment on the marketing of the produce",
        "Comment on the Facilities like Irrigation, Labor and transportation facility",
        "Comment on availability of feed/fodder and medical facilities for Livestock",
        "Describe the structure of shed for rearing the livestock",
        "Comments on Income sources, family details, experience in farming",
        "Overall comment on the activity, customer and conclusion on funding",
      ],
    },
  ];

  void goToSection(int index) {
    if (index <= currentSection + 1 || _isSectionComplete(index)) {
      setState(() {
        currentSection = index;
        currentQuestion = 0;
      });
      _pageController.jumpToPage(0);
    }
  }

  bool _isSectionComplete(int idx) {
    if (idx < 4) {
      int start =
          idx == 0
              ? 0
              : idx == 1
              ? 4
              : idx == 2
              ? 8
              : 12;
      int len = idx == 3 ? 2 : 4;
      return scores.sublist(start, start + len).every((s) => s != null);
    }
    return commentControllers.any((c) => c.text.isNotEmpty);
  }

  void next() {
    if (currentSection == 4) {
      _saveComments();
      _showFinalSummary();
    } else if (currentQuestion <
        sections[currentSection]["questions"].length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else if (currentSection < 4) {
      setState(() => currentSection++);
      _pageController.jumpToPage(0);
    }
  }

  void previous() {
    if (currentQuestion > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else if (currentSection > 0) {
      setState(() => currentSection--);
      final prevLen =
          sections[currentSection].containsKey("questions")
              ? sections[currentSection]["questions"].length
              : 0;
      _pageController.jumpToPage(prevLen - 1);
    }
  }

  void onAnswer(int globalIdx, int score, String questionId) {
    setState(() {
      scores[globalIdx] = score;
      scoreCardMap[questionId] = score.toString();
      print('scoreCardMap => $scoreCardMap');
    });
    Future.delayed(const Duration(milliseconds: 300), next);
  }

  int _globalIndex(int s, int q) =>
      s == 0
          ? q
          : s == 1
          ? 4 + q
          : s == 2
          ? 8 + q
          : 12 + q;

  void _showFinalSummary() {
    final a = scores.sublist(0, 4).whereType<int>().fold(0, (s, v) => s + v);
    final b = scores.sublist(4, 8).whereType<int>().fold(0, (s, v) => s + v);
    final c = scores.sublist(8, 12).whereType<int>().fold(0, (s, v) => s + v);
    final d = scores.sublist(12, 14).whereType<int>().fold(0, (s, v) => s + v);
    final total = a + b + c + d;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              "Assessment Complete!",
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Final Score Summary",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _scoreRow(
                    "A. Knowledge & Experience",
                    a,
                    20,
                    Colors.blue.shade700,
                  ),
                  _scoreRow(
                    "B. Land & Farm Condition",
                    b,
                    20,
                    Colors.green.shade700,
                  ),
                  _scoreRow(
                    "C. Financial Stability",
                    c,
                    20,
                    Colors.purple.shade700,
                  ),
                  _scoreRow(
                    "D. Repayment Behaviour",
                    d,
                    10,
                    Colors.orange.shade800,
                  ),
                  const Divider(height: 30, thickness: 2),
                  Text(
                    "TOTAL SCORE: $total / 70",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          total >= 58
                              ? Colors.green[50]
                              : total >= 45
                              ? Colors.amber[50]
                              : Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            total >= 58
                                ? Colors.green
                                : total >= 45
                                ? Colors.amber
                                : Colors.red,
                      ),
                    ),
                    child: Text(
                      total >= 58
                          ? "EXCELLENT – Recommended"
                          : total >= 45
                          ? "GOOD – Eligible with Conditions"
                          : total >= 30
                          ? "MODERATE RISK – Review Required"
                          : "HIGH RISK – Not Recommended",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            total >= 58
                                ? Colors.green[800]
                                : total >= 45
                                ? Colors.amber[800]
                                : Colors.red[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Comments recorded successfully!",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed:
                      () =>
                          Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text(
                    "Submit & Close",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _scoreRow(String label, int score, int max, Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        Text(
          "$score / $max",
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isCommentSection = currentSection == 4;
    final section = sections[currentSection];
    final color = section["color"] as Color;

    // Calculate progress
    double progress;
    if (isCommentSection) {
      final filledComments =
          commentControllers.where((c) => c.text.trim().isNotEmpty).length;
      progress = filledComments / 9;
    } else {
      final questions = section["questions"] as List;
      progress = (currentQuestion + 1) / questions.length;
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // SECTION HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                Text(
                  section["subtitle"],
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  section["title"],
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!isCommentSection) ...[
                  const SizedBox(height: 16),
                  Text(
                    "Question ${currentQuestion + 1} of ${section["questions"].length}",
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // SECTION TABS
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children:
                  sections.asMap().entries.map((e) {
                    final i = e.key;
                    final s = e.value;
                    final completed =
                        i < 4
                            ? _isSectionComplete(i)
                            : commentControllers.any((c) => c.text.isNotEmpty);
                    final current = i == currentSection;
                    final canAccess =
                        i <= currentSection + 1 || _isSectionComplete(i);

                    return GestureDetector(
                      onTap: canAccess ? () => goToSection(i) : null,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color:
                              current
                                  ? s["color"]
                                  : completed
                                  ? s["color"].withOpacity(0.8)
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(30),
                          border:
                              current
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                        ),
                        child: Row(
                          children: [
                            if (completed)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                            if (!completed && current)
                              const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            if (!completed && !current && canAccess)
                              const Icon(
                                Icons.radio_button_unchecked,
                                color: Colors.white70,
                                size: 20,
                              ),
                            const SizedBox(width: 8),
                            Text(
                              s["subtitle"],
                              style: TextStyle(
                                color:
                                    current || completed
                                        ? Colors.white
                                        : Colors.grey[700],
                                fontWeight:
                                    current ? FontWeight.bold : FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // PROGRESS INDICATOR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          const SizedBox(height: 20),

          // CONTENT
          Expanded(
            child:
                isCommentSection
                    ? _buildCommentsSection()
                    : _buildQuestionsSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsSection() {
    final questions = sections[currentSection]["questions"] as List;
    return PageView.builder(
      // physics: const NeverScrollableScrollingPhysics(),
      controller: _pageController,
      onPageChanged: (i) => setState(() => currentQuestion = i),
      itemCount: questions.length,
      itemBuilder: (context, qIdx) {
        final q = questions[qIdx];
        final globalIdx = _globalIndex(currentSection, qIdx);
        final selected = scores[globalIdx];

        return _questionCard(
          q,
          selected,
          globalIdx,
          sections[currentSection]["color"],
        );
      },
    );
  }

  Widget _questionCard(
    Map<String, dynamic> q,
    int? selected,
    int globalIdx,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                q["q"],
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: q["options"].length,
                  itemBuilder: (_, i) {
                    final opt = q["options"][i];
                    final isSelected = selected == opt["score"];
                    return RadioListTile<int>(
                      title: Text(
                        opt["text"],
                        style: const TextStyle(fontSize: 16, height: 1.45),
                      ),
                      value: opt["score"],
                      groupValue: selected,
                      activeColor: color,
                      secondary: CircleAvatar(
                        radius: 20,
                        backgroundColor: isSelected ? color : Colors.grey[300],
                        child: Text(
                          "${opt["score"]}",
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onChanged:
                          (v) => onAnswer(globalIdx, v!, q["QuestionId"]),
                    );
                  },
                ),
              ),
              _navButtons(color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    final comments = sections[4]["comments"] as List<String>;
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: comments.length,
      itemBuilder: (context, i) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comments[i],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: commentControllers[i],
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Enter your observations here...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  onChanged: (value) {
                    _saveComments();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _navButtons(Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed:
                currentSection > 0 || currentQuestion > 0 ? previous : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text("Previous"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600]),
          ),
          ElevatedButton.icon(
            onPressed: next,
            icon: const Icon(Icons.arrow_forward),
            label: Text(currentSection == 4 ? "Submit" : "Next"),
            style: ElevatedButton.styleFrom(backgroundColor: color),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var c in commentControllers) {
      c.dispose();
    }
    super.dispose();
  }
}
