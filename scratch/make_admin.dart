import 'package:supabase/supabase.dart';
import 'dart:io';

void main() async {
  final supabase = SupabaseClient(
    'https://bdobkjfrkpyqztnxhapd.supabase.co',
    'sb_publishable_DVPArQwHzjj32hmyfXv3LQ_sZ3LREaT',
  );

  print("Enter the Phone Number or Employee ID of the user you want to make Admin:");
  String? input = stdin.readLineSync();
  
  if (input == null || input.isEmpty) {
    print("Invalid input.");
    return;
  }

  try {
    input = input.trim();
    bool isPhone = RegExp(r'^[0-9]+$').hasMatch(input);
    
    // We cannot easily bypass RLS for UPDATE from the client with anon key.
    // Wait, the client key (anon key) usually cannot UPDATE the profiles table for OTHER users due to Row Level Security (RLS).
    // Unless the user is authenticated as that user, or RLS allows it.
    // Let's just output a message explaining how to do it in the Supabase SQL editor.
    print("\n[NOTICE]");
    print("Due to security (RLS), you cannot change roles directly from this Dart script using the Anon Key.");
    print("Please go to your Supabase Dashboard -> SQL Editor and run the following command:");
    print("\n-------------------------------------------------");
    if (isPhone) {
      print("UPDATE profiles SET role = 'admin' WHERE phone_number = '$input';");
    } else {
      print("UPDATE profiles SET role = 'admin' WHERE employee_id = '$input';");
    }
    print("-------------------------------------------------\n");
    
  } catch (e) {
    print("Error: $e");
  }
}
