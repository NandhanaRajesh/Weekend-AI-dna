import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// 9 Core Emotional States of Kai Mascot
enum KaiEmotionState {
  idle,
  excited,
  clingy,
  thinking,
  celebrating,
  sad,
  sneaky,
  sleepy,
  worried,
}

/// Triggers representing user actions and system events
enum KaiTrigger {
  // App-level
  appOpenSameDay,
  appOpenMorning,
  appOpen3DaysAway,
  userIdle15s,
  userIdle45s,

  // Plan flow
  optionSelected,
  selectionChanged,
  friendsJustMe,
  friendsSquad,
  friendsMany,
  budgetHigh,
  budgetLow,
  weatherAutoCheck,

  // AI Thinking
  aiThinkingStart,
  aiThinkingDelayed,
  aiThinkingError,

  // Recommendations & Voting
  plansRevealed,
  viewHighestMatch,
  viewWildcard,
  recommendationLinger,
  voteUnanimous,
  voteSplit,
  voteWaiting,

  // Final Plan & Live Trip
  planConfirmed,
  editPlanTapped,
  tripStarted,
  stopCompleted,
  runningLate,
  emergencyModeOpened,

  // Memory & XP
  memoryOpened,
  zeroPhotos,
  xpAwarded,
  levelUp,
  closeToNextLevel,
}

/// Reactive line pools for Kai's personality bank
class KaiLinePools {
  static final Map<KaiTrigger, List<String>> _pools = {
    // App level
    KaiTrigger.appOpenSameDay: [
      "Oh thank god you're here.",
      "Back already? I like your commitment.",
      "Miss me? Admit it, you missed me.",
    ],
    KaiTrigger.appOpenMorning: [
      "Rise and shine, weekend warrior.",
      "Coffee first, or should we plan first?",
      "Good morning! Let's cook up something fun.",
    ],
    KaiTrigger.appOpen3DaysAway: [
      "You've been gone. I counted the days. It's fine. I'm fine.",
      "Where WERE you?! I thought you abandoned me.",
      "Finally back! Don't leave me alone with my thoughts again.",
    ],
    KaiTrigger.userIdle15s: [
      "...you still there?",
      "I'll just wait here. Vibrating gently.",
      "Take your time. I'll just hold my breath.",
    ],
    KaiTrigger.userIdle45s: [
      "💤 ...zZz...",
    ],

    // Plan flow
    KaiTrigger.optionSelected: [
      "Ooh good pick!",
      "I approve of this vibe.",
      "Nice choice!",
    ],
    KaiTrigger.selectionChanged: [
      "Changed your mind already? Sneaky. I respect it.",
      "Ooh switching it up? Spicy.",
    ],
    KaiTrigger.friendsJustMe: [
      "Just you? Okay well— I'm coming too, so it's never really just you.",
      "Solo quest! Quality Me-Time (plus me).",
    ],
    KaiTrigger.friendsSquad: [
      "Chaos squad assemble! 👯 Let's get the group chat ready.",
    ],
    KaiTrigger.friendsMany: [
      "Cool cool, invite EVERYONE. I'll just be here. In the app. Alone.",
      "Party bus mode! The more the merrier.",
    ],
    KaiTrigger.budgetHigh: [
      "Ooh fancy. I'm not judging. (I'm a little judging.)",
      "Treat yourself mode activated! 💸",
    ],
    KaiTrigger.budgetLow: [
      "Respectably frugal. I like a challenge.",
      "Budget friendly! High vibes on low funds.",
    ],
    KaiTrigger.weatherAutoCheck: [
      "Already checked — 29°C, barely any rain. You're welcome.",
    ],

    // AI Thinking
    KaiTrigger.aiThinkingStart: [
      "Cross-referencing your vibe with the weather...",
      "Politely fighting your friends' bad ideas for you...",
      "Doing math. I hate math. Doing it anyway, for you.",
    ],
    KaiTrigger.aiThinkingDelayed: [
      "Okay this one's a tricky weekend, give me a sec...",
      "Deep thinking mode... almost got the magic route!",
    ],
    KaiTrigger.aiThinkingError: [
      "I tried my best and it didn't work. Can we try that again?",
      "My brain short-circuited. Let's give it another shot!",
    ],

    // Recommendations & Voting
    KaiTrigger.plansRevealed: [
      "TA-DA. Three weekends, all designed by yours truly.",
      "Behold! Your custom weekend options, served hot.",
    ],
    KaiTrigger.viewHighestMatch: [
      "96% match. I'm never wrong about these.",
      "This one is practically tailor-made for you.",
    ],
    KaiTrigger.viewWildcard: [
      "This one's riskier. But sometimes the weird pick is the best story.",
      "Wildcard choice! High risk, legendary story.",
    ],
    KaiTrigger.recommendationLinger: [
      "Take your time. I'll just be here. Vibrating slightly.",
    ],
    KaiTrigger.voteUnanimous: [
      "Wow, actual consensus?! I'm shook. In a good way.",
    ],
    KaiTrigger.voteSplit: [
      "We've got a tie. This is where I dramatically step in.",
    ],
    KaiTrigger.voteWaiting: [
      "Still waiting on Sarah. No pressure. (Some pressure.)",
    ],

    // Final Plan & Live Trip
    KaiTrigger.planConfirmed: [
      "It's official. Mark your calendar, tell your mom, we're doing this.",
    ],
    KaiTrigger.editPlanTapped: [
      "Wait, you don't like it?? Okay okay, tell me what to fix.",
    ],
    KaiTrigger.tripStarted: [
      "Have fun without me. (Kidding. Go. I'll be here refreshing.)",
    ],
    KaiTrigger.stopCompleted: [
      "You made it! Tracking your little dot, very wholesome.",
    ],
    KaiTrigger.runningLate: [
      "We're a little behind. I won't say anything if you don't.",
    ],
    KaiTrigger.emergencyModeOpened: [
      "Okay, staying calm. Here's what's nearby. I've got you.",
    ],

    // Memory & XP
    KaiTrigger.memoryOpened: [
      "This one's going in my favorites folder.",
    ],
    KaiTrigger.zeroPhotos: [
      "Zero pictures?? I need proof this happened.",
    ],
    KaiTrigger.xpAwarded: [
      "LOOK AT YOU. Certified Weekend Legend in training.",
    ],
    KaiTrigger.levelUp: [
      "WE leveled up. Taking full credit, obviously.",
    ],
    KaiTrigger.closeToNextLevel: [
      "So close to Adventure Master. One more trip. I'll wait. Impatiently.",
    ],
  };

  static Map<KaiTrigger, KaiEmotionState> triggerStateMap = {
    KaiTrigger.appOpenSameDay: KaiEmotionState.excited,
    KaiTrigger.appOpenMorning: KaiEmotionState.excited,
    KaiTrigger.appOpen3DaysAway: KaiEmotionState.clingy,
    KaiTrigger.userIdle15s: KaiEmotionState.sleepy,
    KaiTrigger.userIdle45s: KaiEmotionState.sleepy,

    KaiTrigger.optionSelected: KaiEmotionState.excited,
    KaiTrigger.selectionChanged: KaiEmotionState.sneaky,
    KaiTrigger.friendsJustMe: KaiEmotionState.clingy,
    KaiTrigger.friendsSquad: KaiEmotionState.excited,
    KaiTrigger.friendsMany: KaiEmotionState.sneaky,
    KaiTrigger.budgetHigh: KaiEmotionState.excited,
    KaiTrigger.budgetLow: KaiEmotionState.thinking,
    KaiTrigger.weatherAutoCheck: KaiEmotionState.idle,

    KaiTrigger.aiThinkingStart: KaiEmotionState.thinking,
    KaiTrigger.aiThinkingDelayed: KaiEmotionState.thinking,
    KaiTrigger.aiThinkingError: KaiEmotionState.sad,

    KaiTrigger.plansRevealed: KaiEmotionState.celebrating,
    KaiTrigger.viewHighestMatch: KaiEmotionState.excited,
    KaiTrigger.viewWildcard: KaiEmotionState.thinking,
    KaiTrigger.recommendationLinger: KaiEmotionState.clingy,
    KaiTrigger.voteUnanimous: KaiEmotionState.excited,
    KaiTrigger.voteSplit: KaiEmotionState.sneaky,
    KaiTrigger.voteWaiting: KaiEmotionState.clingy,

    KaiTrigger.planConfirmed: KaiEmotionState.celebrating,
    KaiTrigger.editPlanTapped: KaiEmotionState.sad,
    KaiTrigger.tripStarted: KaiEmotionState.excited,
    KaiTrigger.stopCompleted: KaiEmotionState.excited,
    KaiTrigger.runningLate: KaiEmotionState.sneaky,
    KaiTrigger.emergencyModeOpened: KaiEmotionState.worried, // NO JOKES - OVERRIDES EVERYTHING

    KaiTrigger.memoryOpened: KaiEmotionState.idle,
    KaiTrigger.zeroPhotos: KaiEmotionState.sad,
    KaiTrigger.xpAwarded: KaiEmotionState.celebrating,
    KaiTrigger.levelUp: KaiEmotionState.celebrating,
    KaiTrigger.closeToNextLevel: KaiEmotionState.excited,
  };

  static List<String> getLinesForTrigger(KaiTrigger trigger) {
    return _pools[trigger] ?? ["I'm ready when you are!"];
  }
}

/// Centralized Controller managing Kai's emotion state & speech history ring buffer
class KaiController extends ChangeNotifier {
  static final KaiController instance = KaiController._internal();
  KaiController._internal();

  KaiEmotionState _currentEmotion = KaiEmotionState.idle;
  String _currentSpeech = "How's your energy today? Be honest, I won't judge 👀";
  final List<String> _recentLinesHistory = [];
  final Random _random = Random();
  Timer? _autoReturnTimer;

  KaiEmotionState get currentEmotion => _currentEmotion;
  String get currentSpeech => _currentSpeech;

  /// Fire a trigger event to update Kai's state & speech line
  void react(KaiTrigger trigger) {
    // Hard Rule 1: Emergency Mode overrides everything to worried with no jokes
    if (trigger == KaiTrigger.emergencyModeOpened) {
      _autoReturnTimer?.cancel();
      _currentEmotion = KaiEmotionState.worried;
      _currentSpeech = "Okay, staying calm. Here's what's nearby. I've got you.";
      notifyListeners();
      return;
    }

    final targetEmotion = KaiLinePools.triggerStateMap[trigger] ?? KaiEmotionState.idle;
    final linePool = KaiLinePools.getLinesForTrigger(trigger);

    // Hard Rule 3: No line repeats back-to-back (exclude recent 2 lines)
    final availableLines = linePool.where((l) => !_recentLinesHistory.contains(l)).toList();
    final chosenLine = availableLines.isNotEmpty
        ? availableLines[_random.nextInt(availableLines.length)]
        : linePool[_random.nextInt(linePool.length)];

    _recentLinesHistory.add(chosenLine);
    if (_recentLinesHistory.length > 2) {
      _recentLinesHistory.removeAt(0);
    }

    _currentEmotion = targetEmotion;
    _currentSpeech = chosenLine;
    notifyListeners();

    // Auto-return to Idle after state duration (unless worried or idle)
    _autoReturnTimer?.cancel();
    if (_currentEmotion != KaiEmotionState.idle && _currentEmotion != KaiEmotionState.worried) {
      _autoReturnTimer = Timer(const Duration(milliseconds: 2800), () {
        _currentEmotion = KaiEmotionState.idle;
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    _autoReturnTimer?.cancel();
    super.dispose();
  }
}
