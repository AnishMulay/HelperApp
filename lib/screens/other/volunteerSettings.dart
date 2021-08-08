import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helper/providers/themes.dart';
import 'package:helper/screens/other/volunteerCompleted.dart';
import 'package:helper/screens/other/volunteerHome.dart';
import 'package:helper/screens/other/volunteerProfile.dart';
import 'package:helper/screens/taskScreens/volunteered.dart';
import 'package:provider/provider.dart';

class VolunteerSettingsPage extends StatefulWidget {
  const VolunteerSettingsPage({Key? key}) : super(key: key);

  @override
  _VolunteerSettingsPageState createState() => _VolunteerSettingsPageState();
}

class _VolunteerSettingsPageState extends State<VolunteerSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Settings', style: GoogleFonts.montserrat(fontSize: 18)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<ThemeNotifier>(
            builder: (context, notifier, child) {
              return SwitchListTile(
                  title: Text('Alternate Theme', style: GoogleFonts.montserrat(fontSize: 18)),
                  value: notifier.darkTheme,
                  onChanged: (value) {
                    notifier.toggleTheme();
                  });
            },
          )
        ],
      ),
    );
  }
}
