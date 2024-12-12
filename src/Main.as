const string PluginName = Meta::ExecutingPlugin().Name;
const string MenuIconColor = "\\$f5d";
const string PluginIcon = Icons::Users;
const string MenuTitle = MenuIconColor + PluginIcon + "\\$z " + PluginName;

uint64 g_PatchedPtrWRUint32 = 0;

void Main() {
    Run();
}

void Run() {
    if (Apply()) {
        UI::ShowNotification(PluginName, "Patch applied");
    } else {
        UI::ShowNotification(PluginName, "Patch failed; ptr found: " + Text::FormatPointer(g_PatchedPtrWRUint32));
    }
}

bool Apply() {
    // BB 30 75 00 00 is unique in tm.exe but has a match in user32, so just add an extra byte (even tho openplanet won't find/patch it anyway)
    if (g_PatchedPtrWRUint32 == 0) g_PatchedPtrWRUint32 = Dev::FindPattern("BB 30 75 00 00 4C");
    if (g_PatchedPtrWRUint32 == 0) return false;
    Dev::Patch(g_PatchedPtrWRUint32 + 4, "7F");
    return true;
}

void Unrun() {
    if (Unapply()) {
        UI::ShowNotification(PluginName, "Patch removed");
    } else {
        // UI::ShowNotification(PluginName, "Patch not found");
    }
}

bool Unapply() {
    if (g_PatchedPtrWRUint32 == 0) return false;
    Dev::Patch(g_PatchedPtrWRUint32 + 4, "00");
    return true;
}

void OnEnabled() {
    Run();
}

void OnDisabled() {
    Unrun();
}
void OnDestroyed() {
    Unrun();
}
