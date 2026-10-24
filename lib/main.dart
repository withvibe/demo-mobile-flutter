import 'package:flutter/material.dart';

void main() => runApp(const FieldOpsApp());

const _accent = Color(0xFF4F46E5);
const _bg = Color(0xFFF6F7F9);
const _ink = Color(0xFF111827);
const _inkSoft = Color(0xFF6B7280);

class Job {
  final String id, customer, task, address, time, tech;
  final JobStatus status;
  const Job(this.id, this.customer, this.task, this.address, this.time,
      this.status, this.tech);
}

enum JobStatus { scheduled, enRoute, onSite, done }

const jobs = [
  Job("J-2041", "Harbor Dental", "HVAC quarterly service", "12 Marina Ave",
      "08:30", JobStatus.done, "Dana"),
  Job("J-2042", "Nova Fitness", "Compressor replacement", "48 King St",
      "10:00", JobStatus.onSite, "Omar"),
  Job("J-2043", "Cedar House Café", "Walk-in cooler inspection",
      "3 Elm Square", "12:15", JobStatus.enRoute, "Dana"),
  Job("J-2044", "Brightline Offices", "Thermostat install (x6)",
      "200 Summit Blvd", "14:00", JobStatus.scheduled, "Maya"),
  Job("J-2045", "Loft 29 Apartments", "Leak check, unit 7B", "29 Dockside Rd",
      "16:30", JobStatus.scheduled, "Omar"),
];

String statusLabel(JobStatus s) => switch (s) {
      JobStatus.scheduled => "Scheduled",
      JobStatus.enRoute => "En route",
      JobStatus.onSite => "On site",
      JobStatus.done => "Done",
    };

Color statusColor(JobStatus s) => switch (s) {
      JobStatus.scheduled => const Color(0xFFD1D5DB),
      JobStatus.enRoute => _accent,
      JobStatus.onSite => const Color(0xFFB45309),
      JobStatus.done => const Color(0xFF059669),
    };

class FieldOpsApp extends StatelessWidget {
  const FieldOpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FieldOps",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _accent),
        scaffoldBackgroundColor: _bg,
        fontFamily: null,
      ),
      home: const Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: [const HomeTab(), const JobsTab(), const ProfileTab()][tab],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFEEF2FF),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.assignment_outlined), label: "Jobs"),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final remaining = jobs.where((j) => j.status != JobStatus.done).length;
    final next =
        jobs.where((j) => j.status == JobStatus.scheduled).firstOrNull;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("Good morning, Dana",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w700, color: _ink)),
        const SizedBox(height: 4),
        Text("Tuesday · ${jobs.length} jobs today, $remaining to go",
            style: const TextStyle(fontSize: 14, color: _inkSoft)),
        const SizedBox(height: 18),
        Row(children: [
          _stat("${jobs.length - remaining}", "Completed"),
          const SizedBox(width: 10),
          _stat("$remaining", "Remaining"),
          const SizedBox(width: 10),
          _stat("98%", "On time"),
        ]),
        if (next != null) ...[
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: _accent, borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("UP NEXT · ${next.time}",
                  style: const TextStyle(
                      color: Color(0xFFC7D2FE),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1)),
              const SizedBox(height: 6),
              Text(next.customer,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700)),
              Text(next.task,
                  style: const TextStyle(
                      color: Color(0xFFE0E7FF), fontSize: 14)),
              const SizedBox(height: 10),
              Text("${next.address} · ${statusLabel(next.status)}",
                  style: const TextStyle(
                      color: Color(0xFFC7D2FE), fontSize: 13)),
            ]),
          ),
        ],
        const SizedBox(height: 24),
        const Text("TODAY",
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: .6,
                color: _inkSoft)),
        const SizedBox(height: 10),
        ...jobs.map((j) => _todayRow(j)),
      ],
    );
  }

  Widget _stat(String num, String label) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: _cardDeco,
          child: Column(children: [
            Text(num,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700, color: _ink)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, color: _inkSoft)),
          ]),
        ),
      );

  Widget _todayRow(Job j) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: _cardDeco,
        child: Row(children: [
          SizedBox(
              width: 52,
              child: Text(j.time,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _inkSoft))),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(j.customer,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600, color: _ink)),
              Text(j.task,
                  style: const TextStyle(fontSize: 13, color: _inkSoft)),
            ]),
          ),
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: statusColor(j.status), shape: BoxShape.circle)),
        ]),
      );
}

class JobsTab extends StatefulWidget {
  const JobsTab({super.key});
  @override
  State<JobsTab> createState() => _JobsTabState();
}

class _JobsTabState extends State<JobsTab> {
  JobStatus? filter;

  @override
  Widget build(BuildContext context) {
    final visible =
        filter == null ? jobs : jobs.where((j) => j.status == filter).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Text("Jobs",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w700, color: _ink)),
      ),
      SizedBox(
        height: 56,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            _chip("All", filter == null, () => setState(() => filter = null)),
            for (final s in JobStatus.values)
              _chip(statusLabel(s), filter == s,
                  () => setState(() => filter = s)),
          ],
        ),
      ),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [for (final j in visible) _jobCard(j)],
        ),
      ),
    ]);
  }

  Widget _chip(String label, bool active, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: active ? _ink : Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                  color: active ? _ink : const Color(0xFFE5E7EB)),
            ),
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : _inkSoft)),
          ),
        ),
      );

  Widget _jobCard(Job j) {
    final c = statusColor(j.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(j.id,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: _inkSoft)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: c.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(999)),
            child: Text(statusLabel(j.status),
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: c)),
          ),
        ]),
        const SizedBox(height: 8),
        Text(j.customer,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: _ink)),
        Text(j.task, style: const TextStyle(fontSize: 14, color: _inkSoft)),
        const SizedBox(height: 10),
        Text("${j.time} · ${j.address} · ${j.tech}",
            style: const TextStyle(fontSize: 13, color: _inkSoft)),
      ]),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(20), children: [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDeco,
        child: Row(children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: Color(0xFFEEF2FF),
            child: Text("DK",
                style: TextStyle(
                    color: _accent, fontWeight: FontWeight.w700, fontSize: 17)),
          ),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text("Dana Kedem",
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w700, color: _ink)),
            SizedBox(height: 2),
            Text("Senior technician · North team",
                style: TextStyle(fontSize: 13, color: _inkSoft)),
          ]),
        ]),
      ),
      const SizedBox(height: 24),
      const Text("THIS WEEK",
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: .6,
              color: _inkSoft)),
      const SizedBox(height: 10),
      Row(children: [
        _week("23", "Jobs closed"),
        const SizedBox(width: 10),
        _week("4.9", "Avg rating"),
        const SizedBox(width: 10),
        _week("31h", "On site"),
      ]),
      const SizedBox(height: 24),
      Container(
        decoration: _cardDeco,
        child: Column(children: const [
          _PrefRow(label: "Notifications", toggled: true),
          Divider(height: 1, color: Color(0xFFE5E7EB)),
          _PrefRow(label: "Share live location", toggled: true),
          Divider(height: 1, color: Color(0xFFE5E7EB)),
          _PrefRow(label: "Region", value: "Tel Aviv district"),
          Divider(height: 1, color: Color(0xFFE5E7EB)),
          _PrefRow(label: "App version", value: "2.4.1 (Flutter)"),
        ]),
      ),
    ]);
  }

  Widget _week(String num, String label) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: _cardDeco,
          child: Column(children: [
            Text(num,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w700, color: _ink)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, color: _inkSoft)),
          ]),
        ),
      );
}

class _PrefRow extends StatefulWidget {
  final String label;
  final String? value;
  final bool? toggled;
  const _PrefRow({required this.label, this.value, this.toggled});

  @override
  State<_PrefRow> createState() => _PrefRowState();
}

class _PrefRowState extends State<_PrefRow> {
  late bool on = widget.toggled ?? false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(children: [
        Expanded(
            child: Text(widget.label,
                style: const TextStyle(fontSize: 15, color: _ink))),
        if (widget.value != null)
          Text(widget.value!,
              style: const TextStyle(fontSize: 14, color: _inkSoft)),
        if (widget.toggled != null)
          Switch(
              value: on,
              activeTrackColor: _accent,
              onChanged: (v) => setState(() => on = v)),
      ]),
    );
  }
}

final _cardDeco = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: const Color(0xFFE5E7EB)),
);
