package ai.anvika.android.ui

import androidx.compose.runtime.Composable
import ai.anvika.android.MainViewModel
import ai.anvika.android.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}
