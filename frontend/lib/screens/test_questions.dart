final Map<String, dynamic> testData = {
  'depression': {
    'title': 'Depression Assessment',
    'questions': [
      "I feel consistently sad or down.",
      "I feel hopeless or pessimistic about the future.",
      "I often feel like a failure.",
      "I no longer find pleasure in things I once enjoyed.",
      "I frequently feel guilty or ashamed.",
      "I feel like I'm being punished or deserve punishment.",
      "I'm disappointed in myself most of the time.",
      "I often blame myself for things that go wrong.",
      "I have had thoughts of harming myself.",
      "I cry more often than usual.",
      "I find myself feeling irritable or angry.",
      "I feel detached or uninterested in people around me.",
      "I struggle to make decisions, even small ones.",
      "I feel unattractive or not good enough.",
      "I have difficulty falling or staying asleep.",
      "I often feel physically exhausted.",
      "I have noticed changes in my appetite.",
      "I find it difficult to concentrate.",
      "I no longer enjoy activities I used to look forward to.",
      "I feel like my situation will never improve.",
      "Even simple tasks feel overwhelming or exhausting."
    ].map((q) => {
      'question': q,
      'options': ['Not at all', 'Several days', 'More than half the days', 'Nearly every day'],
      'scores': [0, 1, 2, 3]
    }).toList(),
  },

  'anxiety': {
    'title': 'Anxiety Assessment',
    'questions': [
      "I feel more anxious or worried than usual.",
      "I often feel afraid without a clear reason.",
      "I become easily upset or panicked.",
      "I sometimes feel like I'm falling apart emotionally.",
      "I generally feel calm and relaxed.",
      "My hands or legs tremble unexpectedly.",
      "I experience frequent tension in my neck, shoulders, or back.",
      "I often feel physically drained or weak.",
      "I can sit quietly without feeling restless.",
      "My heart races or pounds for no reason.",
      "I occasionally feel lightheaded or dizzy.",
      "I sometimes feel like I might faint.",
      "I breathe comfortably and without effort.",
      "I experience sudden temperature changes (hot flashes or chills).",
      "I need to use the bathroom more frequently due to nerves.",
      "My hands feel sweaty or clammy.",
      "My face flushes or becomes red easily.",
      "I have frequent disturbing dreams or nightmares."
    ].map((q) => {
      'question': q,
      'options': ['Not at all', 'Mildly', 'Moderately', 'Severely'],
      'scores': [0, 1, 2, 3]
    }).toList(),
  },

  'stress': {
    'title': 'Stress Assessment',
    'questions': [
      "I felt overwhelmed by unexpected events.",
      "I felt a lack of control over important aspects of my life.",
      "I felt nervous, anxious, or on edge.",
      "I felt I could manage daily responsibilities well.",
      "I coped effectively with major life changes.",
      "Things in my life felt under control.",
      "I felt I had too many tasks to handle.",
      "I was able to manage everyday frustrations.",
      "I felt confident handling personal issues.",
      "I felt like problems were piling up too quickly.",
      "I was frustrated by things beyond my control.",
      "I struggled to manage my time efficiently.",
      "Stress affected my sleep quality.",
      "I felt excessive pressure from work or studies.",
      "My responsibilities felt too heavy to carry."
    ].map((q) => {
      'question': q,
      'options': ['Never', 'Sometimes', 'Often', 'Very Often'],
      'scores': [0, 1, 2, 3]
    }).toList(),
  },

  'self_esteem': {
    'title': 'Self-Esteem Assessment',
    'questions': [
      "I believe I am a person of worth.",
      "I see many good qualities in myself.",
      "I often feel like a failure.",
      "I consider myself as capable as others.",
      "I lack pride in my accomplishments.",
      "I take a positive view of myself.",
      "I am generally satisfied with who I am.",
      "I wish I had more respect for myself.",
      "Sometimes I feel completely useless.",
      "I feel I am not valuable.",
      "I trust in my abilities.",
      "I consider myself successful.",
      "I accept my flaws and mistakes.",
      "I am proud of my identity.",
      "I usually trust my decisions.",
      "I feel worthy of respect from others.",
      "I’m becoming a person I like.",
      "I feel secure and grounded in who I am.",
      "I am hopeful and confident about my future.",
      "I treat myself with compassion and kindness."
    ].map((q) => {
      'question': q,
      'options': ['Strongly Disagree', 'Disagree', 'Agree', 'Strongly Agree'],
      'scores': [0, 1, 2, 3]
    }).toList(),
  },
};